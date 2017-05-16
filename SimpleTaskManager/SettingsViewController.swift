//
//  SettingsViewController.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 25/06/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    let standardUserDefaults = UserDefaults.standard
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var tasksOrderSegmentedControl: UISegmentedControl!

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // set current values
        notificationsSwitch.setOn(standardUserDefaults.bool(forKey: "notifications"), animated: false)
        let orderByDate = standardUserDefaults.bool(forKey: "orderTasksByDate")
        if(orderByDate){
            tasksOrderSegmentedControl.selectedSegmentIndex = 0 //orderByDate
        } else {
            tasksOrderSegmentedControl.selectedSegmentIndex = 1 //orderByAlphabet
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: User Interaction
    @IBAction func notificationsSettingChanged(_ sender: AnyObject) {
        if(notificationsSwitch.isOn){
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        } else {
            NotificationsController.removeAllNotifications()
        }
        
        standardUserDefaults.set(notificationsSwitch.isOn, forKey: "notifications")
    }
    
    @IBAction func tasksOrderChanged(_ sender: AnyObject) {
        let orderByDate = tasksOrderSegmentedControl.selectedSegmentIndex == 0 //segment 0 == date
        standardUserDefaults.set(orderByDate, forKey: "orderTasksByDate")
    }
}
