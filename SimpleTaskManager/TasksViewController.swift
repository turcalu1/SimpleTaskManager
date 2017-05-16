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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var tasks: [Task] = []
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(TasksViewController.swipeRight(_:)))
        swipe.direction = .right
        self.tableView.addGestureRecognizer(swipe)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadTasks(){
        tasks = TaskPersistencyManager.sharedInstance.getTasks(UserDefaults.standard.bool(forKey: "orderTasksByDate") ? true : false)
    }
    
    // MARK: - Table view
    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView,
                   cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        
        var attributedTitle = [String : AnyObject]()
        if task.is_done {
            attributedTitle = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue as AnyObject]
        }
        cell.textLabel!.attributedText = NSAttributedString(string: task.name!, attributes: attributedTitle)
        
        cell.backgroundColor = Array(Common.COLORS.keys)[ task.category!.getColorID() ]
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let dueDate = dayTimePeriodFormatter.string(from: task.getDueDate() as Date)
        
        var attributedSubtitle = [String : AnyObject]()
        if Date().addingTimeInterval(60*60*24*15).compare(task.getDueDate() as Date) == .orderedDescending  {
            attributedSubtitle = [
                                  //NSForegroundColorAttributeName : UIColor.red,
                                  NSFontAttributeName : UIFont.boldSystemFont(ofSize: 13)]
        }
        cell.detailTextLabel!.attributedText = NSAttributedString(string: dueDate, attributes: attributedSubtitle)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addNewTaskViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AddTask") as! AddNewTaskViewController
        addNewTaskViewControllerObj.setUpdateState(tasks[indexPath.row])
        self.navigationController?.pushViewController(addNewTaskViewControllerObj, animated: true)
    }

    // MARK: User Interaction
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { //deleted task
        if editingStyle == .delete {
            TaskPersistencyManager.sharedInstance.removeTask(tasks[indexPath.row])
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func swipeRight(_ recognizer: UIGestureRecognizer) { //task is done
        if recognizer.state == UIGestureRecognizerState.ended {
            let swipeLocation = recognizer.location(in: self.tableView)
            if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation) {
                if (self.tableView.cellForRow(at: swipedIndexPath) != nil) {

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

