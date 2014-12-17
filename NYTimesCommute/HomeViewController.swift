//
//  ViewController.swift
//  NYCommute
//
//  Created by Louis SERRE on 16/12/2014.
//  Copyright (c) 2014 EQUIPE_11. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController{
    @IBOutlet var activity: UIActivityIndicatorView!
    
    var articlesData = []
    
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
        
        activity.startAnimating()
        getRedditJSON("http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1?api-key=93344f496633c8f3886831c3b9984910:14:70443089")
        
        saveArticles()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRedditJSON(whichReddit : String){
        let mySession = NSURLSession.sharedSession()
        let url: NSURL = NSURL(string: whichReddit)!
        let networkTask = mySession.dataTaskWithURL(url, completionHandler : {data, response, error -> Void in
            var err: NSErrorPointer = nil
            
            println(data)
            
            if data.length>0 {
                
                var theJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: err) as NSMutableDictionary
                let results : NSArray = theJSON["results"] as NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.articlesData = results
                    self.saveArticles()
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ArticlesTableViewController") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                })

            }
            
        })
        networkTask.resume()
    }
    
    func saveArticles(){

        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        for articleData in self.articlesData {
            let newArticle = NSEntityDescription.insertNewObjectForEntityForName("Article", inManagedObjectContext: managedContext) as NSManagedObject
            
            newArticle.setValue(articleData["title"], forKey: "title")
            newArticle.setValue(articleData["abstract"], forKey: "content")
            
            managedContext.save(nil)
            
            
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
        
    }
    
}