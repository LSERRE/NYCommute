//
//  ArticleTableViewCellController.swift
//  NYTimesCommute
//
//  Created by Louis SERRE on 18/12/2014.
//  Copyright (c) 2014 loicsaintroch. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ArticlesTableViewCell: UITableViewCell{
    
    @IBOutlet weak var readNow: UIButton!
    @IBOutlet weak var articleThumbnail: UIImageView!
    @IBOutlet weak var articleDate: UILabel!
    @IBOutlet weak var articleContent: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleLocation: UILabel!
}