//
//  Common.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 04/07/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import UIKit

class Common: NSObject {
    static var COLORS = [UIColor.grayColor()  : "Gray",
                  UIColor.greenColor() : "Green",
                  UIColor.cyanColor() : "Cyan",
                  UIColor.yellowColor() : "Yellow",
                  UIColor.orangeColor() : "Orange",
                  UIColor.brownColor() : "Brown"]
    
    static var DEFAULT_CATEGORIES = [ "School", "Work", "Wife", "Kids" ]
    
    static var DEFAULT_TASKS = [ "Learn a new technique in iOS development",
                                "Finish this app before the deadline",
                                "Tell Mona a great joke",
                                "Help Jimmy with his homework" ]
    
    class func addDayAndHourToDate(day: Int, hour: Int, date: NSDate) -> NSDate {
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.day = day
        dateComponents.hour = hour
        
        let gregorianCalendar: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let newDate: NSDate = gregorianCalendar.dateByAddingComponents(dateComponents, toDate: date, options:NSCalendarOptions(rawValue: 0))!
        
        return newDate
    }
}
