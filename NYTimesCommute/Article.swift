//
//  NYTimesCommute.swift
//  NYTimesCommute
//
//  Created by Louis SERRE on 18/12/2014.
//  Copyright (c) 2014 loicsaintroch. All rights reserved.
//

import Foundation
import CoreData

class Article: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var thumbnail: String
    @NSManaged var title: String
    @NSManaged var location: String
    @NSManaged var date: String
    @NSManaged var url: String

}
