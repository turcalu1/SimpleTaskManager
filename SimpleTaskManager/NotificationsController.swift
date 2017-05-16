//
//  NotificationsController.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 04/07/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import UIKit

class NotificationsController: NSObject {
    class func scheduleNotification(_ task: Task){
        if let settings = UIApplication.shared.currentUserNotificationSettings
        {
            if !settings.types.contains([.alert, .badge, .sound])
            {
                //notifications are not allowed
                NotificationsController.removeAllNotifications()
                UserDefaults.standard.set(false, forKey: "notifications")
                return
            }
        }
        
        let fireDate = Common.addDayAndHourToDate(0, hour: 8, date: task.value(forKey: "due") as! Date)
        
//      if(Date() > fireDate){
        if Date().compare(fireDate) == .orderedAscending  {
                return
        }
        
        let notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.alertBody = "Due today: " + task.name!
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["uuid": UUID().uuidString]
        UIApplication.shared.scheduleLocalNotification(notification)
        
        TaskPersistencyManager.sharedInstance.updateTask(task, notification_uuid: task.name)
    }
    
    class func removeExistingNotification(_ task: Task){
        if( task.notification_uuid == "" ){
            return
        }
        
        let notifications = UIApplication.shared.scheduledLocalNotifications!
        for notification in notifications {
            if( notification.userInfo!["uuid"] as? String == task.notification_uuid ){
                UIApplication.shared.cancelLocalNotification(notification)
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
        UIApplication.shared.cancelAllLocalNotifications()
    }
}
