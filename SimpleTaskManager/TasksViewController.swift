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
    var tasks: [Task] = []
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(TasksViewController.swipeRight(_:)))
        swipe.direction = .Right
        self.tableView.addGestureRecognizer(swipe)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadTasks(){
        tasks = TaskPersistencyManager.sharedInstance.getTasks(NSUserDefaults.standardUserDefaults().boolForKey("orderTasksByDate") ? true : false)
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
        if task.is_done {
            attributedTitle = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        }
        cell.textLabel!.attributedText = NSAttributedString(string: task.name!, attributes: attributedTitle)
        
        cell.backgroundColor = Array(Common.COLORS.keys)[ task.category!.getColorID() ]
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE, MMM d, yyyy"
        var dueDate = dayTimePeriodFormatter.stringFromDate(task.getDueDate())
        
//        var attributedSubtitle = [String : AnyObject]()
        if NSDate() > task.getDueDate() {
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

    // MARK: User Interaction
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) { //deleted task
        if editingStyle == .Delete {
            TaskPersistencyManager.sharedInstance.removeTask(tasks[indexPath.row])
            tasks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func swipeRight(recognizer: UIGestureRecognizer) { //task is done
        if recognizer.state == UIGestureRecognizerState.Ended {
            let swipeLocation = recognizer.locationInView(self.tableView)
            if let swipedIndexPath = tableView.indexPathForRowAtPoint(swipeLocation) {
                if (self.tableView.cellForRowAtIndexPath(swipedIndexPath) != nil) {

                    let task = tasks[swipedIndexPath.row]
                    var is_done = false
                    if !task.is_done {
                        is_done = true
                        NotificationsController.removeExistingNotification(task)
                    }
                    
                    TaskPersistencyManager.sharedInstance.updateTask(task, is_done: is_done)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

