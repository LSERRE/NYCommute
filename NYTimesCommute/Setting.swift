//
//  Setting.swift
//  NYTimesCommute
//
//  Created by Louis SERRE on 17/12/2014.
//  Copyright (c) 2014 loicsaintroch. All rights reserved.
//

import Foundation
import CoreData

class Setting: NSManagedObject {

    @NSManaged var hours: NSDate
    @NSManaged var categories: NSSet

}
