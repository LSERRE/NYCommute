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

    var articlesData = []
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    

    @IBOutlet weak var activity: UIActivityIndicatorView!
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
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        activity.startAnimating()
        getNYTJSON("http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1?api-key=93344f496633c8f3886831c3b9984910:14:70443089")
        
        appDelegate.resetCoreData()
        saveArticles()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNYTJSON(NYTUrl : String){
        let mySession = NSURLSession.sharedSession()
        let url: NSURL = NSURL(string: NYTUrl)!
        let networkTask = mySession.dataTaskWithURL(url, completionHandler : {data, response, error -> Void in
            var err: NSErrorPointer = nil
            
            if data.length>0 {
                
                var theJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: err) as NSMutableDictionary
                let results : NSArray = theJSON["results"] as NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.articlesData = results
                    self.saveArticles()
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ArticlesNavigationController") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                })

            }
            
        })
        networkTask.resume()
    }
    
    func saveArticles(){

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        for articleData in self.articlesData {
            let newArticle = NSEntityDescription.insertNewObjectForEntityForName("Article", inManagedObjectContext: managedContext) as NSManagedObject
            
            var thumbnail =  UIImage(data: NSData(contentsOfURL: NSURL(string:"http://static01.nyt.com/images/2014/12/18/fashion/18SUBREFORMATION/18SUBREFORMATION-articleLarge.jpg")!)!)
            
            var location = articleData["geo_facet"]
            
            if let stringArray = location as? [String] {
                location = " ".join(stringArray)
            }
            
            var dateString :NSString? = articleData["published_date"] as? NSString // change to your date format
            
            var dateFormatter = NSDateFormatter()
            // this is imporant - we set our input date format to match our input string
            dateFormatter.dateFormat = "dd-MM-yyyy"
            // voila!
            var date = dateFormatter.dateFromString(dateString!)
            
            var imageData = UIImageJPEGRepresentation(thumbnail, 1)
            let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
            newArticle.setValue(articleData["title"], forKey: "title")
            newArticle.setValue(articleData["abstract"], forKey: "content")
            newArticle.setValue(location, forKey: "location")
            newArticle.setValue(date, forKey: "date")
            newArticle.setValue(articleData["url"], forKey: "url")
            newArticle.setValue(base64String, forKey: "thumbnail")
            
            managedContext.save(nil)
            
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
        
    }
    
}