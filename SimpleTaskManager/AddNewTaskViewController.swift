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
    var task : Task?
    var categories : [Category] = []
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskCategory: UIPickerView!
    @IBOutlet weak var taskDeadline: UIDatePicker!
    @IBOutlet weak var taskEnabledNotifications: UISwitch!
    @IBOutlet weak var taskSaveButton: UIBarButtonItem!
    @IBOutlet weak var taskIsFinishedButton: UIButton!
    
    // MARK: Lifecycle
    func setUpdateState(_ task: Task!){
        self.task = task
    }
    
    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categories = CategoryPersistencyManager.sharedInstance.getCategories()
        
        self.taskCategory.dataSource = self
        self.taskCategory.delegate = self
        
        var selectedCategoryIdx = 0
        
        // Set task values
        if let _task = task {
            title = "Update Task"
            
            taskName.text = _task.name
            taskDeadline.setDate(_task.getDueDate() as Date, animated: false)
            
            var enabledNotif = false
            if(!UserDefaults.standard.bool(forKey: "notifications") || _task.is_done){
                taskEnabledNotifications.isEnabled = false
            } else {
                if(_task.notification_uuid != ""){
                    enabledNotif = true
                }
            }
            taskEnabledNotifications.setOn(enabledNotif, animated: false)
            
            for (i,c) in categories.enumerated(){
                if(c === _task.category){
                    selectedCategoryIdx = i
                }
            }
            
            if(_task.is_done){
                taskIsFinishedButton.setTitle("Task is not Done", for: UIControlState())
            }
            
        } else {
            taskIsFinishedButton.isHidden = true
        }
        
        //select color & update background
        taskCategory.selectRow(selectedCategoryIdx, inComponent: 0, animated: false)
        pickerView(taskCategory, didSelectRow: selectedCategoryIdx, inComponent: 0)

    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    //MARK: pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let cat = categories[row]
        let color = UIColor.black
        
        return NSAttributedString(string: cat.name!, attributes: [NSForegroundColorAttributeName:color])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let cat = categories[row]
        let color = Array(Common.COLORS.keys)[cat.getColorID()]
        self.view.backgroundColor = color
    }
    
    //MARK: Task Related Methods
    func saveTask(_ name: String, dueDate: Date, notification: Bool, category: Category) {
        var _task = task
        
        if _task != nil {
            TaskPersistencyManager.sharedInstance.updateTask(_task!, due: dueDate, name: name, category: category)
        } else {
            _task = TaskPersistencyManager.sharedInstance.createTask(name, due: dueDate, category: category)
        }
        
        //notification
        if(UserDefaults.standard.bool(forKey: "notifications")){
            if task != nil {
                NotificationsController.removeExistingNotification(_task!)
            }
            if(notification){
                NotificationsController.scheduleNotification(_task!)
            }
        }
    }
    
    // MARK: User Interaction
    @IBAction func saveTask(_ sender: AnyObject) {
        if (taskName.text!.isEmpty) {
            let alertController = UIAlertController(title: "No task name", message: "Please enter a task name", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion:nil)
            return
        }
        
        saveTask(taskName.text!, dueDate: taskDeadline.date, notification: taskEnabledNotifications.isOn, category: categories[taskCategory.selectedRow(inComponent: 0)])
        
        _ = self.navigationController?.popToRootViewController(animated: true) // return to list view
    }
    
    @IBAction func taskIsFinished(_ sender: AnyObject) {
        let isFinished = (task!.is_done) ? false : true
        
        TaskPersistencyManager.sharedInstance.updateTask(task!, is_done: isFinished)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
