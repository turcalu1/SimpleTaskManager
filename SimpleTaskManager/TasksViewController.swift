//
//  TasksViewController.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 25/06/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: UITableViewController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var tasks = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(TasksViewController.swipeRight(_:)))
        swipe.direction = .Right
        self.tableView.addGestureRecognizer(swipe)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view
    override func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(tableView: UITableView,
                   cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let task = tasks[indexPath.row]
        
        var attributedTitle = [String : AnyObject]()
        if task.valueForKey("is_done") as! Bool {
            attributedTitle = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        }
        cell.textLabel!.attributedText = NSAttributedString(string: task.valueForKey("name") as! String, attributes: attributedTitle)
        
        let colorID = (task.valueForKey("category") as! NSManagedObject).valueForKey("color_id") as! Int
        cell.backgroundColor = Array(COLORS.keys)[colorID]
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE, MMM d, yyyy"
        var dueDate = dayTimePeriodFormatter.stringFromDate(task.valueForKey("due") as! NSDate)
        
//        var attributedSubtitle = [String : AnyObject]()
        if NSDate() > task.valueForKey("due") as! NSDate {
            dueDate = "[Soon] " + dueDate
//            attributedSubtitle = [NSForegroundColorAttributeName : UIColor.darkGrayColor()]
//            attributedSubtitle = [NSFontAttributeName : UIFont.boldSystemFontOfSize(11)]
        }
//        cell.detailTextLabel!.attributedText = NSAttributedString(string: dueDate, attributes: attributedSubtitle)
        cell.detailTextLabel!.text = dueDate
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let addNewTaskViewControllerObj = self.storyboard?.instantiateViewControllerWithIdentifier("AddTask") as! AddNewTaskViewController
        addNewTaskViewControllerObj.setUpdateState(tasks[indexPath.row])
        self.navigationController?.pushViewController(addNewTaskViewControllerObj, animated: true)
    }
    
    
    func loadTasks(){
        let standardUserDefaults = NSUserDefaults.standardUserDefaults()
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Task")
        
        if(standardUserDefaults.boolForKey("orderTasksByDate")){
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "due", ascending: true)]
        } else {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        }
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            tasks = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    // MARK: - Remove task
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            removeTask(tasks[indexPath.row])
            tasks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func removeTask(task: NSManagedObject){
        let managedContext = appDelegate.managedObjectContext
        managedContext.deleteObject(task)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unable to remove task \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Completed Task
    func swipeRight(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Ended {
            let swipeLocation = recognizer.locationInView(self.tableView)
            if let swipedIndexPath = tableView.indexPathForRowAtPoint(swipeLocation) {
                if (self.tableView.cellForRowAtIndexPath(swipedIndexPath) != nil) {

                    let task = tasks[swipedIndexPath.row] 
                    if task.valueForKey("is_done") as! Bool {
                        task.setValue(false, forKey: "is_done")
                    } else {
                        task.setValue(true, forKey: "is_done")
                        appDelegate.removeExistingNotification(task)
                    }

                    saveUpdatedTask(task)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func saveUpdatedTask(task: NSManagedObject){
        // save your changes
        do {
            try task.managedObjectContext?.save()
        } catch let error as NSError {
            print("Unable to update task \(error), \(error.userInfo)")
        }
    }
}

