//
//  AppDelegate.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 25/06/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import UIKit
import CoreData

var COLORS = [UIColor.grayColor()  : "Gray",
              UIColor.greenColor() : "Green",
              UIColor.cyanColor() : "Cyan",
              UIColor.yellowColor() : "Yellow",
              UIColor.orangeColor() : "Orange",
              UIColor.brownColor() : "Brown"]

var DEFAULT_CATEGORIES = [ "School", "Work", "Wife", "Kids" ]

var DEFAULT_TASKS = [ "Learn a new technique in iOS development",
                      "Finish this app before the deadline",
                      "Tell Mona a great joke",
                      "Help Jimmy with his homework" ]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let standardUserDefaults = NSUserDefaults.standardUserDefaults()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //preload default settings
        let isPreloaded = standardUserDefaults.boolForKey("isPreloaded")
        if !isPreloaded {
            preloadData()
            standardUserDefaults.setBool(true, forKey: "isPreloaded")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "cody.SimpleTaskManager" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SimpleTaskManager", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - Task Categories
    var categories = [NSManagedObject]()
    
    func loadCategories(){
        let managedContext = managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            categories = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Preload Data
    func preloadData () {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // default settings
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "notifications")
        defaults.setBool(true, forKey: "orderTasksByDate")
        
        var cats = [NSManagedObject]()
        
        for (i,c) in DEFAULT_CATEGORIES.enumerate() {
            let newC = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: managedObjectContext)
            newC.setValue(c, forKey: "name")
            newC.setValue(i, forKey: "color_id")

            do {
                try managedContext.save()
                cats.append(newC)
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        let today = NSDate()
        let addNewTaskViewControllerObj = AddNewTaskViewController()
        
        for (i,c) in DEFAULT_TASKS.enumerate() {
            let dueDate = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: i,
                toDate: today,
                options: NSCalendarOptions.MatchStrictly)
            
            addNewTaskViewControllerObj.saveTask(c, dueDate: dueDate!, notification: false, category: cats[i])
        }
    }
    
    // MARK: - Schedule notifications
    func scheduleNotification(task: NSManagedObject){
        if let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        {
            if !settings.types.contains([.Alert, .Badge, .Sound])
            {
                //notifications are not allowed
                removeAllNotifications()
                standardUserDefaults.setBool(false, forKey: "notifications")
                return
            }
        }
        
        
        let fireDate = addDayAndHourToDate(0, hour: 8, date: task.valueForKey("due") as! NSDate)
        
        if(NSDate() > fireDate){
            return
        }
        
        let notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.alertBody = "Due today: " + (task.valueForKey("name") as! String)
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["uuid": NSUUID().UUIDString]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        task.setValue(notification.userInfo!["uuid"], forKey: "notification_uuid")
    }
    
    func removeExistingNotification(task: NSManagedObject){
        let uuid = task.valueForKey("notification_uuid") as? String
        if( uuid == "" ){
            return
        }
        
        let notifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        for notification in notifications {
            if( notification.userInfo!["uuid"] as? String == uuid ){
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
        
        task.setValue("", forKey: "notification_uuid")
    }
    
    func removeAllNotifications(){
        //remove uuids - less effcient way
        let taskViewControllerObj = TasksViewController()
        taskViewControllerObj.loadTasks()
        
        for t in taskViewControllerObj.tasks{
            t.setValue("", forKey: "notification_uuid")
            taskViewControllerObj.saveUpdatedTask(t)
        }
        
        //remove notifs
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func addDayAndHourToDate(day: Int, hour: Int, date: NSDate) -> NSDate {
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.day = day
        dateComponents.hour = hour
        
        let gregorianCalendar: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let newDate: NSDate = gregorianCalendar.dateByAddingComponents(dateComponents, toDate: date, options:NSCalendarOptions(rawValue: 0))!
        
        return newDate
    }
    
    
    
}

