//
//  AddNewTaskViewController.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 26/06/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import UIKit
import CoreData

class AddNewTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var updateTaskObj : NSManagedObject!
    var updateTaskCategoryObj : NSManagedObject!
    var updateTask = false
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskCategory: UIPickerView!
    @IBOutlet weak var taskDeadline: UIDatePicker!
    @IBOutlet weak var taskEnabledNotifications: UISwitch!
    @IBOutlet weak var taskSaveButton: UIBarButtonItem!
    @IBOutlet weak var taskIsFinishedButton: UIButton!
    
    func setUpdateState(task: NSManagedObject){
        updateTaskObj = task
        updateTask = true
        updateTaskCategoryObj = updateTaskObj.valueForKey("category") as? NSManagedObject
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.loadCategories()
        
        self.taskCategory.dataSource = self
        self.taskCategory.delegate = self
        
        var selectedCategoryIdx = 0
        
        // Set task values
        if (updateTask){
            title = "Update Task"
            
            taskName.text = updateTaskObj.valueForKey("name") as? String
            taskDeadline.setDate(updateTaskObj.valueForKey("due") as! NSDate, animated: false)
            
            var enabledNotif = false
            if(!NSUserDefaults.standardUserDefaults().boolForKey("notifications") || updateTaskObj.valueForKey("is_done") as! Bool){
                taskEnabledNotifications.enabled = false
            } else {
                if(updateTaskObj.valueForKey("notification_uuid") as! String != ""){
                    enabledNotif = true
                }
            }
            taskEnabledNotifications.setOn(enabledNotif, animated: false)
            
            for (i,c) in appDelegate.categories.enumerate(){
                if(c === updateTaskCategoryObj){
                    selectedCategoryIdx = i
                }
            }
            
            if(updateTaskObj.valueForKey("is_done") as! Bool){
                taskIsFinishedButton.setTitle("Task is not Done", forState: .Normal)
            }
            
        } else {
            taskIsFinishedButton.hidden = true
        }
        
        //select color & update background
        taskCategory.selectRow(selectedCategoryIdx, inComponent: 0, animated: false)
        pickerView(taskCategory, didSelectRow: selectedCategoryIdx, inComponent: 0)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - pickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appDelegate.categories.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let cat = appDelegate.categories[row]
        let color = UIColor.blackColor()
        
        return NSAttributedString(string: cat.valueForKey("name") as! String, attributes: [NSForegroundColorAttributeName:color])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let cat = appDelegate.categories[row]
        let color = Array(COLORS.keys)[cat.valueForKey("color_id") as! Int]
        self.view.backgroundColor = color
    }
    
    //MARK: - Save task
    func removeTimeFromDate(date: NSDate) -> NSDate{
        return NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.startOfDayForDate(date)
    }
    
    func saveTask(name: String, dueDate: NSDate, notification: Bool, category: NSManagedObject) {
        let managedContext = appDelegate.managedObjectContext
        var task = updateTaskObj
        
        if(!updateTask){
            let entity =  NSEntityDescription.entityForName("Task",
                                                            inManagedObjectContext:managedContext)
            task = NSManagedObject(entity: entity!,
                                       insertIntoManagedObjectContext: managedContext)
            task.setValue("", forKey: "notification_uuid")
        }
        
        task.setValue(name, forKey: "name")
        task.setValue(removeTimeFromDate(dueDate), forKey: "due")
        if(!updateTask){
            task.setValue(false, forKey: "is_done")
        }
        task.setValue(category, forKey: "category")

        
        //notification
        if(NSUserDefaults.standardUserDefaults().boolForKey("notifications")){
            if(updateTask){
                appDelegate.removeExistingNotification(task)
            }
            if(notification){
                appDelegate.scheduleNotification(task)
            }
        }
        
        do {
            try managedContext.save()

        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Button callbacks
    @IBAction func saveTask(sender: AnyObject) {
        if (taskName.text!.isEmpty) {
            let alert = UIAlertView()
            alert.title = "No task name"
            alert.message = "Please enter a task name"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        }
        
        saveTask(taskName.text!, dueDate: taskDeadline.date, notification: taskEnabledNotifications.on, category: appDelegate.categories[taskCategory.selectedRowInComponent(0)])
        
        self.navigationController?.popToRootViewControllerAnimated(true) // return to list view
    }
    
    @IBAction func taskIsFinished(sender: AnyObject) {
        var isFinished = true
        if(updateTaskObj.valueForKey("is_done") as! Bool){
            isFinished = false
        }
        updateTaskObj.setValue(isFinished, forKey: "is_done")

        let n: Int! = self.navigationController?.viewControllers.count
        let taskViewControllerObj = self.navigationController?.viewControllers[n-2] as! TasksViewController
        taskViewControllerObj.saveUpdatedTask(updateTaskObj)
        
        appDelegate.removeExistingNotification(updateTaskObj)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
