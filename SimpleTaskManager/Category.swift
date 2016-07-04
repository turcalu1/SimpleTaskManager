//
//  Category.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 04/07/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import Foundation
import CoreData


class Category: NSManagedObject {
    func getColorID() -> Int{
        return Int(color_id)
    }
}
