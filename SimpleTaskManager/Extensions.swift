//
//  Extensions.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 27/06/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import Foundation

// From http://stackoverflow.com/questions/26198526/nsdate-comparison-using-swift
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}
public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}
public func >(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedDescending
}
extension NSDate: Comparable { }