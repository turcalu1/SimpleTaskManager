//
//  SettingsViewController.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 25/06/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var standardUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var tasksOrderSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // set current values
        notificationsSwitch.setOn(standardUserDefaults.boolForKey("notifications"), animated: false)
        let orderByDate = standardUserDefaults.boolForKey("orderTasksByDate")
        if(orderByDate){
            tasksOrderSegmentedControl.selectedSegmentIndex = 0 //orderByDate
        } else {
            tasksOrderSegmentedControl.selectedSegmentIndex = 1 //orderByAlphabet
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Button callbacks
    @IBAction func notificationsSettingChanged(sender: AnyObject) {
        if(notificationsSwitch.on){
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        } else {
            appDelegate.removeAllNotifications()
        }
        
        standardUserDefaults.setBool(notificationsSwitch.on, forKey: "notifications")
    }
    
    @IBAction func tasksOrderChanged(sender: AnyObject) {
        let orderByDate = tasksOrderSegmentedControl.selectedSegmentIndex == 0 //segment 0 == date
        standardUserDefaults.setBool(orderByDate, forKey: "orderTasksByDate")
    }
}
