//
//  PersistanceUtils.swift
//  I'm Free
//
//  Created by Ian Washburne on 2/26/15.
//  Copyright (c) 2015 Ian Washburne. All rights reserved.
//

import Foundation

class PersistanceUtils {
   
   class func write(value: AnyObject, forKey: String) {
      let manager = NSFileManager.defaultManager()
      let docURL: NSURL? = manager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil)
      
      if let docURL = docURL? {
         var data = NSMutableDictionary(contentsOfFile: "\(docURL.path!)/appData.txt")
         if let data = data? {
            data.setValue(value, forKey: forKey)
         } else {
            data = NSMutableDictionary()
            data!.setValue(value, forKey: forKey)
         }
         data!.writeToFile("\(docURL.path!)/appData.txt", atomically: true)
      }
      
   }
   
   class func read(key: String) -> AnyObject? {
      let manager = NSFileManager.defaultManager()
      let docURL: NSURL? = manager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil)
      
      if let docURL = docURL? {
         var data = NSMutableDictionary(contentsOfFile: "\(docURL.path!)/appData.txt")
         if let data = data? {
            return data.valueForKey(key)
         }
      }
      
      return nil
   }
   
   class func clear(key: String) {
      let manager = NSFileManager.defaultManager()
      let docURL: NSURL? = manager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil)
      
      if let docURL = docURL? {
         var data = NSMutableDictionary(contentsOfFile: "\(docURL.path!)/appData.txt")
         if let data = data? {
            data.setValue("", forKey: key)
            
            data.writeToFile("\(docURL.path!)/appData.txt", atomically: true)
         }
      }
   }
   
   class func dropCredentials() {
      clear("username")
      clear("password")
   }
   
   class func printFileLoc() {
      let manager = NSFileManager.defaultManager()
      let docURL: NSURL? = manager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil)
      if let docURL = docURL? {
         println("\(docURL.path!)")
      }
   }
   
}
