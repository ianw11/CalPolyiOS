//
//  AssignmentTableViewController.swift
//  GradebookExample
//
//  Created by Ian Washburne on 3/3/15.
//  Copyright (c) 2015 John Bellardo. All rights reserved.
//

import UIKit
import Foundation

class AssignmentCell: UITableViewCell {
   
   required init(coder aDecoder: NSCoder) {
      data = nil
      super.init(coder: aDecoder)
   }
   
   @IBOutlet weak var dataLabel: UILabel!
   
   var title = ""
   var data: String? {
      didSet {
         if let data = data? {
            dataLabel.text = "\(title): \(data)"
            
         } else {
            dataLabel.text = "EMPTY"
            title = ""
         }
      }
   }
   
   override func prepareForReuse() {
      data = nil
      title = ""
   }
   
   
}

class AssignmentTableViewController: UITableViewController {
   
   var url = ""
   var username = ""
   var password = ""
   
   var term = 0
   var course = ""
   var id = 0
   
   var display_scores: [String] = []
   
   var assignmentData: JSON? {
      didSet {
         var i = startCounter
         
         if let ad = assignmentData?["asnstats"] {
            
            if ad["points"].float == nil {
               dataArr[i++] = Float(ad["points"].int!)
            } else {
               dataArr[i++] = ad["points"].float!
            }
            
            if ad["min_score"].float == nil {
               dataArr[i++] = Float(ad["min_score"].int!)
            } else {
               dataArr[i++] = ad["min_score"].float!
            }
            
            if ad["max_score"].float == nil {
               dataArr[i++] = Float(ad["max_score"].int!)
            } else {
               dataArr[i++] = ad["max_score"].float!
            }
            
            if ad["median_score"].float == nil {
               dataArr[i++] = Float(ad["median_score"].int!)
            } else {
               dataArr[i++] = ad["median_score"].float!
            }
            
            if ad["mean_score"].float == nil {
               dataArr[i++] = Float(ad["mean_score"].int!)
            } else {
               dataArr[i++] = ad["mean_score"].float!
            }
            
            if ad["unique_students"].float == nil {
               dataArr[i++] = Float(ad["unique_students"].int!)
            } else {
               dataArr[i++] = ad["unique_students"].float!
            }
            
            if ad["std_dev"].float == nil {
               dataArr[i++] = Float(ad["std_dev"].int!)
            } else {
               dataArr[i++] = ad["std_dev"].float!
            }
            
            if ad["attempts"].float == nil {
               dataArr[i++] = Float(ad["attempts"].int!)
            } else {
               dataArr[i++] = ad["attempts"].float!
            }
            
            if ad["id"].float == nil {
               dataArr[i++] = Float(ad["id"].int!)
            } else {
               dataArr[i++] = ad["id"].float!
            }
            
            
         }
         self.tableView.reloadData()
      }
   }
   
   let startCounter = 1
   
   var titleArr = [  "Display Score",
                     "Points",
                     "Min Score",
                     "Max Score",
                     "Median Score",
                     "Mean Score"
   ];
   var dataArr: [Float] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
   
   let reuseIdentifier = "assignmentCell"
   
   func loadData() {
      let loader = GradebookURLLoader()
      // Run the loader
      loader.baseURL = url
      
      if loader.loginWithUsername(username, andPassword: password) {
         
         let data = loader.loadDataFromPath("?record=asnstats&term=\(term)&course=\(course)&id=\(id)", error: nil)
         let str = NSString(data: data, encoding: NSUTF8StringEncoding)
         if str!.hasPrefix("\"Incorrect permission") {
            titleArr = [ "Display Score" ]
            self.tableView.reloadData()
         } else {
            assignmentData = JSON(data: data)
         }
         
      }
      else {
         println("Auth failed!")
      }
   }

   override func viewDidLoad() {
       super.viewDidLoad()
      
      loadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      return display_scores.count
   }


   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as AssignmentCell

      // Configure the cell...
      
      //if indexPath.row == 0 {
         cell.title = titleArr[0]
         cell.data = display_scores[indexPath.row]
         return cell
      //}
      
         //cell.title = titleArr[indexPath.row]
         //cell.data = "\(dataArr[indexPath.row])"

      //return cell
   }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
