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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
   /*
    * Member variables
    */

   let myLabel: SKLabelNode = SKLabelNode(fontNamed:"Chalkduster")
   let scoreLabel: SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")

   let faby = SKSpriteNode(imageNamed: "bird_twitter")

   var hasGameStarted = false

   var audioPlayer = AVAudioPlayer() // Temporary assignment, until later
   
   let ROCK_CATEGORY: UInt32 = 0x1
   let PLAYER_CATEGORY: UInt32 = 0x2
   let EDGE_CATEGORY: UInt32 = 0x4
   
   var score = 0;
   

   /*
    * The onCreate of iOS
    */
   override func didMoveToView(view: SKView) {
      
      self.removeAllChildren()
      hasGameStarted = false
      
      score = 0
      
      /* Show welcome message */
      myLabel.text = "Tap to begin!";
      myLabel.fontSize = 55;
      myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
      self.addChild(myLabel)
      
      /* Prepare audio */
      audioPlayer = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("upSound", withExtension: "mp3"), error: nil);
      audioPlayer.prepareToPlay()

   }
   
   override func update(currentTime: CFTimeInterval) {
      /* Called before each frame is rendered */
   }
   
   
   /*
    * didChangeSize is called when the screen rotates.
    * It needs to update the borders of the game
    */
   override func didChangeSize(oldSize: CGSize) {
      super.didChangeSize(oldSize)
      
      let newRect = CGRect(x: self.frame.origin.x - 100.0, y: self.frame.origin.y, width: self.frame.width + 100.0, height: self.frame.height)
      self.physicsBody = SKPhysicsBody(edgeLoopFromRect: newRect)
      self.physicsBody?.categoryBitMask = EDGE_CATEGORY;
      
      if (hasGameStarted) {
         faby.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
      } else {
         myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
      }
   }
   
   /* Randomization helper functions */
   // myRandf returns a number between 0 and 1
   func myRandf() ->CGFloat {
      return CGFloat(Double(arc4random()) / Double(UINT32_MAX))
   }
   
   func myRand(lowerBound low: CGFloat, upperBound high: CGFloat) -> CGFloat {
      return myRandf() * (high - low) + low
   }
   
   
   /* Create an enemy object */
   func spawnEnemy(fileName: String) {
      let rock = SKSpriteNode(imageNamed: fileName)
      let xS = myRand(lowerBound: 0.15, upperBound: 0.3);
      rock.xScale = xS
      rock.yScale = 0.25
      
      rock.position = CGPoint(x: self.size.width, y: myRand(lowerBound: 0, upperBound: self.size.height));
      
      rock.zPosition = faby.zPosition - 10.0
      
      let physicsBody = SKPhysicsBody(circleOfRadius: rock.size.height / 2.0)
      physicsBody.affectedByGravity = false
      physicsBody.linearDamping = 0
      physicsBody.velocity = CGVector(dx: -200, dy: 0)
      physicsBody.categoryBitMask = ROCK_CATEGORY
      physicsBody.collisionBitMask = PLAYER_CATEGORY
      physicsBody.contactTestBitMask = PLAYER_CATEGORY
      rock.physicsBody = physicsBody
      
      addChild(rock)
      
   }
   
   
   func setScoreText() {
      scoreLabel.text = "Score: \(score)"
   }
   
   override func didSimulatePhysics() {
      for node in children {
         if CGRectGetMaxX(node.frame) < 0 {
            node.removeFromParent()
            score++;
            setScoreText()
         }
      }
   }
   
   func didBeginContact(contact: SKPhysicsContact) {
      physicsWorld.speed = 0.0
      faby.removeAllChildren()
      removeAllActions()
      let newScene = GameOverScene()
      newScene.old = self
      newScene.score = score
      view?.presentScene(newScene)
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
            // Start game
            hasGameStarted = true
            
            myLabel.removeFromParent()
            
            /* Add blinking eye */
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
            
            /* Apply a physicsBody to the bird */
            let physicsBody = SKPhysicsBody(texture: faby.texture, size: faby.texture!.size())
            physicsBody.dynamic = true // Turns on physics
            physicsBody.mass = 1.0
            physicsBody.allowsRotation = false // Doesn't let the bird rotate
            physicsBody.collisionBitMask = EDGE_CATEGORY;
            faby.physicsBody = physicsBody

            /* Put faby in the middle of the screen */
            faby.position = CGPoint(x: CGRectGetMidX(self.frame) / 2.0, y: CGRectGetMidY(self.frame))
            
            
            /* Start spawning enemies, forever */
            let addRock = SKAction.sequence([
               SKAction.waitForDuration(0.6, withRange: 0.3),
               SKAction.runBlock {
                  self.spawnEnemy("boulder")
               }
            ])
            let addRockForever = SKAction.repeatActionForever(addRock)
            runAction(addRockForever)
            
            /* Update the physics world */
            physicsWorld.contactDelegate = self
            physicsWorld.speed = 1.0
            
            /* Add the score label */
            scoreLabel.fontSize = 12;
            scoreLabel.fontColor = UIColor.blueColor()
            scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
            setScoreText()
            self.addChild(scoreLabel)

            self.addChild(faby)
         }
      }
   }
}
