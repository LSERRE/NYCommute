//
//  ArticleViewController.swift
//  NYTimesCommute
//
//  Created by Louis SERRE on 16/12/2014.
//  Copyright (c) 2014 loicsaintroch. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var articlesTable: UITableView!
    var articlesData = [Article]()
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Article")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [Article]?
        
        if let results = fetchedResults {
            articlesData = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return articlesData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    
        
        let cell: ArticlesTableViewCell = articlesTable.dequeueReusableCellWithIdentifier("articleCell") as ArticlesTableViewCell
        
        var article = articlesData[indexPath.row]
        
        let decodedData = NSData(base64EncodedString: article.thumbnail, options:NSDataBase64DecodingOptions(rawValue: 0))
        var decodedimage = UIImage(data: decodedData!)

        cell.articleDate.text = article.date
        cell.articleTitle.text = article.title
        cell.articleTitle.numberOfLines = 0;
        cell.articleLocation.text = article.location
        cell.articleContent.text = article.content
        cell.articleContent.numberOfLines = 0;
        cell.articleThumbnail.image = decodedimage
        cell.articleDate.text = article.date
        cell.articleButton.tag = indexPath.row
        cell.articleButton.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func buttonClicked(sender:UIButton) {
        let buttonRow = sender.tag
        self.performSegueWithIdentifier("articleDetailSegue", sender: buttonRow)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "articleDetailSegue") {
            let viewController:ArticleDetailViewController = segue.destinationViewController as ArticleDetailViewController
            let index : Int = sender as Int
            viewController.article = articlesData[index]
        }
    }

    
    
}