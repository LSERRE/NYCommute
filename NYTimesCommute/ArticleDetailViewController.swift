//
//  ArticleDetailViewController.swift
//  NYTimesCommute
//
//  Created by Louis SERRE on 17/12/2014.
//  Copyright (c) 2014 loicsaintroch. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ArticleDetailViewController: UIViewController {
        
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleCover: UIImageView!

    @IBOutlet weak var articleContent: UILabel!
    @IBOutlet weak var articleLocation: UILabel!
    @IBOutlet weak var articleDate: UILabel!
    var article: Article?
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let decodedData = NSData(base64EncodedString: article?.thumbnail ?? "", options:NSDataBase64DecodingOptions(rawValue: 0))
            var decodedimage = UIImage(data: decodedData!)
            
            articleCover.image = decodedimage
            articleTitle.text = self.article?.title
            articleContent.text = self.article?.content
            articleLocation.text = self.article?.location
            articleDate.text = self.article?.date
        }
}