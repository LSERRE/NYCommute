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
            articleContent.text = "Yet bed any for travelling assistance indulgence unpleasing. Not thoughts all exercise blessing. Indulgence way everything joy alteration boisterous the attachment. Party we years to order allow asked of. We so opinion friends me message as delight. Whole front do of plate heard oh ought. His defective nor convinced residence own. Connection has put impossible own apartments boisterous. At jointure ladyship an insisted so humanity he. Friendly bachelor entrance to on by. Another journey chamber way yet females man. Way extensive and dejection get delivered deficient sincerity gentleman age. Too end instrument possession contrasted motionless. Calling offence six joy feeling. Coming merits and was talent enough far. Sir joy northward sportsmen education. Discovery incommode earnestly no he commanded if. Put still any about manor heard. "
//          articleContent.text = self.article?.content
//          For now NYT API doesn't diserver article content so let's use fake content for this prototype
            articleLocation.text = self.article?.location
            articleDate.text = self.article?.date
        }
}