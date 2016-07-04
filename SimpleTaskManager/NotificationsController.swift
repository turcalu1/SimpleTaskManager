//
//  NotificationsController.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 04/07/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import UIKit

class NotificationsController: NSObject {
    class func scheduleNotification(task: Task){
        if let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        {
            if !settings.types.contains([.Alert, .Badge, .Sound])
            {
                //notifications are not allowed
                NotificationsController.removeAllNotifications()
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "notifications")
                return
            }
        }
        
        let fireDate = Common.addDayAndHourToDate(0, hour: 8, date: task.valueForKey("due") as! NSDate)
        
        if(NSDate() > fireDate){
            return
        }
        
        let notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.alertBody = "Due today: " + task.name!
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["uuid": NSUUID().UUIDString]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        TaskPersistencyManager.sharedInstance.updateTask(task, notification_uuid: task.name)
    }
    
    class func removeExistingNotification(task: Task){
        if( task.notification_uuid == "" ){
            return
        }
        
        let notifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        for notification in notifications {
            if( notification.userInfo!["uuid"] as? String == task.notification_uuid ){
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
        
        TaskPersistencyManager.sharedInstance.updateTask(task, notification_uuid: "")
    }
    
    class func removeAllNotifications(){
        //remove uuids - less effcient way
        let tasks = TaskPersistencyManager.sharedInstance.getTasks()
        for t in tasks{
            TaskPersistencyManager.sharedInstance.updateTask(t, notification_uuid: "")
        }
        
        //remove notifs
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
}
