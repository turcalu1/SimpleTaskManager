//
//  Common.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 04/07/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import UIKit

class Common: NSObject {
    static var COLORS = [UIColor.gray  : "Gray",
                  UIColor.green : "Green",
                  UIColor.cyan : "Cyan",
                  UIColor.yellow : "Yellow",
                  UIColor.orange : "Orange",
                  UIColor.brown : "Brown"]
    
    static var DEFAULT_CATEGORIES = [ "School", "Work", "Wife", "Kids" ]
    
    static var DEFAULT_TASKS = [ "Learn a new technique in iOS development",
                                "Finish this app before the deadline",
                                "Tell Mona a great joke",
                                "Help Jimmy with his homework" ]
    
    class func addDayAndHourToDate(_ day: Int, hour: Int, date: Date) -> Date {
        var dateComponents: DateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.hour = hour
        
        let gregorianCalendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate: Date = gregorianCalendar.date(byAdding: dateComponents, to: date)!
        
        return newDate
    }
}
