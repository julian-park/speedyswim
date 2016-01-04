//
//  InfoPage.swift
//  Swimming
//
//  Created by Joonyon Park on 6/7/15.
//  Copyright (c) 2015 Julian Joonyon Park. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

class InfoPage: SKScene, SKPhysicsContactDelegate {
    
    var BGMPlayerIP = AVAudioPlayer(contentsOfURL:NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("BGM", ofType: "mp3")!), error: nil)
    var homeScene = GameScene()
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self

        BGMPlayerIP.play()
        BGMPlayerIP.volume = 0.4
        BGMPlayerIP.numberOfLoops = -1
        
        let SoundDefault = NSUserDefaults.standardUserDefaults()
        if (SoundDefault.valueForKey("SoundValue") != nil) {
            homeScene.SoundValue = SoundDefault.valueForKey("SoundValue") as! NSInteger!
            //fyi: highScoreLbl.text = "\(gameScene.Highscore)" + "m"
            
            BGMPlayerIP.volume = 0
        }
        
        
        let backgroundImage = SKSpriteNode(imageNamed: "Pool.png")
        backgroundImage.setScale(0.6)
        backgroundImage.zPosition = -1
        backgroundImage.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        let scroll = SKAction.moveToY(180, duration: 1)
        let scrollDone = SKAction.moveTo(CGPointMake(self.frame.size.width / 2, self.frame.size.height / 1.82), duration: 0)
        backgroundImage.runAction(SKAction.repeatActionForever(SKAction.sequence([scroll,scrollDone])))
        self.addChild(backgroundImage)
        
        let infoBox = SKSpriteNode(imageNamed: "InfoBox.png")
        infoBox.setScale(0.57)
        infoBox.position = CGPointMake(self.frame.size.width*0.502, self.frame.size.height*0.55)
        infoBox.zPosition = 3
        self.addChild(infoBox)
        
        let back = SKSpriteNode(imageNamed: "Back.png")
        back.setScale(0.3)
        back.position = CGPointMake(self.frame.size.width*0.41, self.frame.size.height*0.26)
        back.zPosition = 4
        back.name = "back"
        self.addChild(back)
        
        let like = SKSpriteNode(imageNamed: "Like.png")
        like.setScale(0.25)
        like.position = CGPointMake(self.frame.size.width*0.59, self.frame.size.height*0.265)
        like.zPosition = 4
        like.name = "like"
        self.addChild(like)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch in (touches as! Set<UITouch>)  {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if (node.name == "back") {
                BGMPlayerIP.stop()
                let homeScene = GameScene(size: self.size)
                homeScene.scaleMode = .AspectFill
                self.view?.presentScene(homeScene)
            } else if (node.name == "like") {
                UIApplication.sharedApplication().openURL(NSURL(string:"https://facebook.com/SpeedySwim")!)
            }
        }
    }
    
}




