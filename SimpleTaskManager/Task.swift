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
    func removeTimeFromDate(date: NSDate) -> NSDate{
        return NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.startOfDayForDate(date)
    }
    func setDueDate(date: NSDate){
        self.due = removeTimeFromDate(date).timeIntervalSince1970
    }
    func getDueDate() -> NSDate{
        return NSDate(timeIntervalSince1970: due)
    }
}
