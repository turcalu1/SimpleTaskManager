//
//  TaskPersistencyManager.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 03/07/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import Foundation
import CoreData

class TaskPersistencyManager: NSObject {
    let moc = DataController.sharedInstance.managedObjectContext
    
    class var sharedInstance: TaskPersistencyManager {
        struct Singleton {
            static let instance = TaskPersistencyManager()
        }
        return Singleton.instance
    }
    
    func getTasks(_ orderByDue: Bool=false) -> [Task]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: orderByDue ? "due" : "name", ascending: true)]
        
        do {
            let results =
                try moc.fetch(fetchRequest)
            return results as! [Task]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    func createTask(_ name: String, due: Date, category: Category) -> Task{
        let entity =  NSEntityDescription.entity(forEntityName: "Task",
                                                        in:moc)
        let task = NSManagedObject(entity: entity!,
                                   insertInto: moc) as! Task
        
        task.notification_uuid = ""
        task.name = name
        task.setDueDate(due)
        task.is_done = false
        task.category = category
        
        DataController.sharedInstance.saveContext()
        return task
    }
    
    func updateTask(_ task: Task,
                    due: Date?=nil,
                    is_done: Bool?=nil,
                    name: String?=nil,
                    notification_uuid: String?=nil,
                    category: Category?=nil ){
        if let _due = due {
            task.setDueDate(_due)
        }
        
        if let _is_done = is_done {
            task.is_done = _is_done
        }
        
        if let _name = name {
            task.name = _name
        }
        
        if let _notification_uuid = notification_uuid {
            task.notification_uuid = _notification_uuid
        }

        if let _category = category {
            task.category = _category
        }

        DataController.sharedInstance.saveContext()
    }
    
    func removeTask(_ task: Task){
        moc.delete(task)
        DataController.sharedInstance.saveContext()
    }
}
