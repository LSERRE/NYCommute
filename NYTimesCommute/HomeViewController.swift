//
//  ViewController.swift
//  NYCommute
//
//  Created by Louis SERRE on 16/12/2014.
//  Copyright (c) 2014 EQUIPE_11. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController{

    var articlesData:JSON!
    

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
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let image1 = UIImage(named: "splashios.png")
        let imageview = UIImageView(image: image1)
        imageview.contentMode = UIViewContentMode.ScaleAspectFill
        imageview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(imageview)
        
        activity.center=self.view.center;
        activity.startAnimating()
        
        appDelegate.resetCoreData()
        
        getJSON()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJSON(){
        Alamofire.request(.GET, "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1?api-key=93344f496633c8f3886831c3b9984910:14:70443089")
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    let realJSON : JSON = JSON(json!) as JSON
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                    
                    let managedContext = appDelegate.managedObjectContext!
                    
                    for (key: String, articleData: JSON) in realJSON["results"] {
                        let newArticle = NSEntityDescription.insertNewObjectForEntityForName("Article", inManagedObjectContext: managedContext) as NSManagedObject
                        
                        if let url : NSString = articleData["media"][0]["media-metadata"][1]["url"].string  {
                            var thumbnail =  UIImage(data: NSData(contentsOfURL: NSURL(string:url)!)!)
                            var imageData = UIImageJPEGRepresentation(thumbnail, 1)
                            let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                            newArticle.setValue(base64String, forKey: "thumbnail")
                        }
                        else{
                            var thumbnail =  UIImage(data: NSData(contentsOfURL: NSURL(string:"http://www.joomlaworks.net/images/demos/galleries/abstract/7.jpg")!)!)
                            var imageData = UIImageJPEGRepresentation(thumbnail, 1)
                            let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                            newArticle.setValue(base64String, forKey: "thumbnail")
                        }
                        
                        newArticle.setValue("World", forKey: "location")
                        newArticle.setValue(articleData["title"].string, forKey: "title")
                        newArticle.setValue(articleData["abstract"].string, forKey: "content")

                        newArticle.setValue(articleData["published_date"].string, forKey: "date")
                        newArticle.setValue(articleData["url"].string, forKey: "url")
                        managedContext.save(nil)
                        var error: NSError?
                        if !managedContext.save(&error) {
                            println("Could not save \(error), \(error?.userInfo)")
                        }
                    }
                }
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ArticlesNavigationController") as UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
        }
    }

}

