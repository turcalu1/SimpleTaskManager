//
//  Task+CoreDataProperties.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 04/07/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var due: NSTimeInterval
    @NSManaged var is_done: Bool
    @NSManaged var name: String?
    @NSManaged var notification_uuid: String?
    @NSManaged var category: Category?

}
