//
//  GameOverScene.swift
//  Faby Bird
//
//  Created by Ian Washburne on 2/3/15.
//  Copyright (c) 2015 Ian Washburne. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
   
   var old: GameScene?
   var score: Int = 0
   var holderScore = 0
   
   override func didMoveToView(view: SKView) {
      size = view.frame.size
      
      let myLabel = SKLabelNode(fontNamed: "Chalkduster")
      myLabel.text = "GAME OVER  Score: \(score)"
      myLabel.fontSize = 18
      myLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) + 50)
      addChild(myLabel)
      
      let scores = updateHighScores()
      
      
      
      let hiScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
      hiScoreLabel.text = "High Score: \(scores[0])"
      hiScoreLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - 50)
      addChild(hiScoreLabel)
      
      if (scores.count > 1) {
         let midScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
         midScoreLabel.text = "Mid Score: \(scores[1])"
         midScoreLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - 100)
         addChild(midScoreLabel)
      }
      
      if (scores.count > 2) {
         let loScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
         loScoreLabel.text = "Low Score: \(scores[2])"
         loScoreLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - 150)
         addChild(loScoreLabel)
      }
      
   }
   
   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
      view?.presentScene(old)
   }
   
   func updateHighScores() -> [Int]{
      var ret : [Int] = []
      
      let manager = NSFileManager.defaultManager()
      let docURL: NSURL? = manager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil)
      
      if let docURL = docURL? {
         //slewson@calpoly.edu
         
         var data = NSMutableDictionary(contentsOfFile: "\(docURL.path!)/highscores.txt")
         if let data = data? {
            if let topScore = data.valueForKey("topScore") as? Int {
               if score > topScore {
                  holderScore = topScore
                  data.setValue(score, forKey: "topScore")
                  score = holderScore
               }
               ret.append(data.valueForKey("topScore") as Int!)
            } else {
               // No topScore exists yet
               data.setValue(score, forKey: "topScore")
               data.writeToFile("\(docURL.path!)/highscores.txt", atomically: true)
               ret.append(score)
               return ret
            }
            
            if let midScore = data.valueForKey("midScore") as? Int {
               if (score > midScore) {
                  holderScore = midScore
                  data.setValue(score, forKey: ("midScore"))
                  score = holderScore
               }
               ret.append(data.valueForKey("midScore") as Int!)
            } else {
               // No midScore exists yet
               data.setValue(score, forKey: "midScore")
               data.writeToFile("\(docURL.path!)/highscores.txt", atomically: true)
               ret.append(score)
               return ret
            }
            
            if let lowScore = data.valueForKey("lowScore") as? Int {
               if (score > lowScore) {
                  holderScore = lowScore
                  data.setValue(score, forKey: ("lowScore"))
                  score = holderScore
               }
               ret.append(data.valueForKey("lowScore") as Int!)
            } else {
               // No midScore exists yet
               data.setValue(score, forKey: "lowScore")
               data.writeToFile("\(docURL.path!)/highscores.txt", atomically: true)
               ret.append(score)
               return ret
            }
            
         } else {
            data = NSMutableDictionary()
            println("File didn't exist yet")
            println("Setting topScore with \(score)")
            data!.setValue(score, forKey: "topScore")
            ret.append(score)
         }
         
         data!.writeToFile("\(docURL.path!)/highscores.txt", atomically: true)
      }
      
      return ret
      
   }
}
