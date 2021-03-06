//
//  CategoryPersistencyManager.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 04/07/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import Foundation
import CoreData

class CategoryPersistencyManager: NSObject {
    let moc = DataController.sharedInstance.managedObjectContext
    
    class var sharedInstance: CategoryPersistencyManager {
        struct Singleton {
            static let instance = CategoryPersistencyManager()
        }
        return Singleton.instance
    }
    
    func getCategories() -> [Category]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        do {
            let results =
                try moc.fetch(fetchRequest)
            return results as! [Category]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    func createCategory(_ color_id: Int, name: String) -> Category{
        let entity =  NSEntityDescription.entity(forEntityName: "Category",
                                                        in:moc)
        let category = NSManagedObject(entity: entity!,
                                   insertInto: moc) as! Category
        
        category.color_id = Int16(color_id)
        category.name = name
        
        DataController.sharedInstance.saveContext()
        return category
    }
    
    func updateCategory(_ category: Category,
                        color_id: Int?=nil,
                        name: String?=nil){
        if let _color_id = color_id {
            category.color_id = Int16(_color_id)
        }
        
        if let _name = name {
            category.name = _name
        }
        
        DataController.sharedInstance.saveContext()
    }
    
    func removeCategory(_ category: Task){
        moc.delete(category)
        DataController.sharedInstance.saveContext()
    }
}
