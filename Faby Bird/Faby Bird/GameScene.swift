//
//  GameScene.swift
//  Faby Bird
//
//  Created by Ian Washburne on 1/8/15.
//  Copyright (c) 2015 Ian Washburne. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
   /*
    * Member variables
    */

   let myLabel: SKLabelNode = SKLabelNode(fontNamed:"Chalkduster")

   let faby = SKSpriteNode(imageNamed: "bird_twitter")

   var hasGameStarted = false

   var audioPlayer = AVAudioPlayer() // Temporary assignment, until later
   

   /*
    * The onCreate of iOS
    */
   override func didMoveToView(view: SKView) {
      
      /* Show welcome message */
      myLabel.text = "Tap to begin!";
      myLabel.fontSize = 55;
      myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
      self.addChild(myLabel)
      
      audioPlayer = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("upSound", withExtension: "mp3"), error: nil);
      audioPlayer.prepareToPlay()

   }
   
   override func update(currentTime: CFTimeInterval) {
      /* Called before each frame is rendered */
   }
   
   override func didChangeSize(oldSize: CGSize) {
      super.didChangeSize(oldSize)
      
      self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
      
      if (hasGameStarted) {
         faby.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
      } else {
         myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
      }
   }

   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
      /* Called when a touch begins */
      for touch: AnyObject in touches {

         if (hasGameStarted) {
            if (audioPlayer.playing) {
               audioPlayer.stop()
            }
            audioPlayer.play()
            
            // Add impulse up
            faby.physicsBody?.applyImpulse(CGVector(dx: CGFloat(0.0), dy: CGFloat(400.0)))
            
         } else {
            hasGameStarted = true
            
            myLabel.text = ""
            
            let eye = SKShapeNode()
            eye.path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: CGFloat(3), startAngle: 0.0, endAngle: CGFloat(2.0 * M_PI), clockwise: false).CGPath
            eye.fillColor = UIColor.whiteColor()
            let blink = SKAction.sequence([SKAction.waitForDuration(1.0),
                  SKAction.fadeOutWithDuration(0.1),
                  SKAction.waitForDuration(0.2),
                  SKAction.fadeInWithDuration(0.1)])
            let blinkForever = SKAction.repeatActionForever(blink)
            eye.runAction(blinkForever)
            eye.position = CGPoint(x: 27, y: 20);
            eye.zPosition = 1.0
            faby.addChild(eye)
            

            let physicsBody = SKPhysicsBody(texture: faby.texture, size: faby.texture!.size())
            physicsBody.dynamic = true // Turns on physics
            physicsBody.mass = 1.0
            physicsBody.allowsRotation = false // Doesn't let the bird rotate
            faby.physicsBody = physicsBody

            //faby.xScale = 0.5
            //faby.yScale = 0.5

            faby.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            //faby.position = touch.locationInNode(self)

            self.addChild(faby)
         }
      }
   }
}
