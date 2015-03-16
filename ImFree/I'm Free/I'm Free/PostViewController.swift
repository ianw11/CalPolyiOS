//
//  PostViewController.swift
//  I'm Free
//
//  Created by Ian Washburne on 3/15/15.
//  Copyright (c) 2015 Ian Washburne. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var timeLabel: UILabel!
   @IBOutlet weak var locationLabel: UILabel!
   
   
   var user: PFUser? = nil
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      /* First label */
      let firstname = user!["FirstName"] as String
      let lastname = user!["LastName"] as String
      
      nameLabel.text = "\(firstname) \(lastname)"
      
      /* Second label */
      let time = user!["TimeFree"] as NSDate
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "hh:mm"
      
      timeLabel.text = "Free Until: \(dateFormatter.stringFromDate(time))"
      
      /* Third label */
      let location = user!["UserLocation"] as String
      
      locationLabel.text = "At: \(location)"
      
      
      
      // Do any additional setup after loading the view.
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
