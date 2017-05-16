//
//  Task.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 04/07/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import Foundation
import CoreData


class Task: NSManagedObject {
    func removeTimeFromDate(_ date: Date) -> Date{
        return Calendar(identifier: Calendar.Identifier.gregorian).startOfDay(for: date)
    }
    func setDueDate(_ date: Date){
        self.due = removeTimeFromDate(date).timeIntervalSince1970
    }
    func getDueDate() -> Date{
        return Date(timeIntervalSince1970: due)
    }
}
