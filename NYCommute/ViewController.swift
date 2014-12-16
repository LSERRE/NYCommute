//
//  ViewController.swift
//  NYCommute
//
//  Created by Louis SERRE on 16/12/2014.
//  Copyright (c) 2014 EQUIPE_11. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var articleList: UITableView!
    var tableData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getRedditJSON("http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1?api-key=93344f496633c8f3886831c3b9984910:14:70443089")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getRedditJSON(whichReddit : String){
        let mySession = NSURLSession.sharedSession()
        let url: NSURL = NSURL(string: whichReddit)!
        let networkTask = mySession.dataTaskWithURL(url, completionHandler : {data, response, error -> Void in
            var err: NSError?
            var theJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSMutableDictionary
            let results : NSArray = theJSON["data"]!["children"] as NSArray
            dispatch_async(dispatch_get_main_queue(), {
                self.tableData = results
                self.articleList!.reloadData()
            })
        })
        networkTask.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        let redditEntry : NSMutableDictionary = self.tableData[indexPath.row] as NSMutableDictionary
        cell.textLabel!.text = (redditEntry["data"]!["title"] as String)
        cell.detailTextLabel!.text = (redditEntry["data"]!["author"] as String)
        return cell
    }
    
    
}

  