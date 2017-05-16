//
//  Extensions.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 27/06/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import Foundation

// From http://stackoverflow.com/questions/26198526/nsdate-comparison-using-swift
public func ==(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedSame
}
public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
}
public func >(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedDescending
}
//extension Date: Comparable { }
