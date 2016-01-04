//
//  GameOverScene.swift
//  Swimming
//
//  Created by Joonyon Park on 5/3/15.
//  Copyright (c) 2015 Julian Joonyon Park. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameKit

class GameOverScene: SKScene, SKPhysicsContactDelegate {
    
    var BGMPlayerGO = AVAudioPlayer(contentsOfURL:NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("BGM", ofType: "mp3")!), error: nil)
    var gameScene = GamePlay()
    var homeScene = GameScene()
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        
        BGMPlayerGO.play()
        BGMPlayerGO.volume = 0.4
        BGMPlayerGO.numberOfLoops = -1
        
        let SoundDefault = NSUserDefaults.standardUserDefaults()
        if (SoundDefault.valueForKey("SoundValue") != nil) {
            homeScene.SoundValue = SoundDefault.valueForKey("SoundValue") as! NSInteger!
            //highScoreLbl.text = "\(gameScene.Highscore)" + "m"
            
            BGMPlayerGO.volume = 0
        }
        
        
        let backgroundImage = SKSpriteNode(imageNamed: "Pool.png")
        backgroundImage.setScale(0.6)
        backgroundImage.zPosition = -1
        backgroundImage.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        let scroll = SKAction.moveToY(180, duration: 1)
        let scrollDone = SKAction.moveTo(CGPointMake(self.frame.size.width / 2, self.frame.size.height / 1.82), duration: 0)
        backgroundImage.runAction(SKAction.repeatActionForever(SKAction.sequence([scroll,scrollDone])))
        self.addChild(backgroundImage)
        
        let gameoverBox = SKSpriteNode(imageNamed: "GameOverBox.png")
        gameoverBox.setScale(0.6)
        gameoverBox.position = CGPointMake(self.frame.size.width*0.501, self.frame.size.height*0.628)
        gameoverBox.zPosition = 3
        self.addChild(gameoverBox)
        
        
        
        let gameScoreLbl = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        gameScoreLbl.position = CGPointMake(self.frame.size.width*0.435, self.frame.size.height*0.565)
        gameScoreLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        gameScoreLbl.fontColor = UIColor.blackColor()
        gameScoreLbl.fontSize = 63
        gameScoreLbl.zPosition = 4
        gameScoreLbl.text = "\(gameScene.Score)" + "m"
        self.addChild(gameScoreLbl)
        
        
        let highScoreLbl = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        highScoreLbl.position = CGPointMake(self.frame.size.width*0.435, self.frame.size.height*0.46)
        highScoreLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        highScoreLbl.fontColor = UIColor.blackColor()
        highScoreLbl.fontSize = 30
        highScoreLbl.zPosition = 4
        self.addChild(highScoreLbl)
        
        let HighscoreDefault = NSUserDefaults.standardUserDefaults()
        if (HighscoreDefault.valueForKey("Highscore") != nil) {
            gameScene.Highscore = HighscoreDefault.valueForKey("Highscore") as! NSInteger!
            highScoreLbl.text = "\(gameScene.Highscore)" + "m"
        }
        
        //new
        if (gameScene.Score >= gameScene.Highscore) {
            let new = SKSpriteNode(imageNamed: "New.png")
            new.setScale(0.2)
            new.position = CGPointMake(self.frame.size.width*0.48, self.frame.size.height*0.52)
            new.zPosition = 5
            self.addChild(new)
        }
        
        //medal
        if (gameScene.Score >= 500) {
            let gold = SKSpriteNode(imageNamed: "Gold.png")
            gold.setScale(0.64)
            gold.position = CGPointMake(self.frame.size.width*0.588, self.frame.size.height*0.55)
            gold.zPosition = 5
            self.addChild(gold)
        } else if (gameScene.Score >= 300) {
            let silver = SKSpriteNode(imageNamed: "Silver.png")
            silver.setScale(0.64)
            silver.position = CGPointMake(self.frame.size.width*0.588, self.frame.size.height*0.55)
            silver.zPosition = 5
            self.addChild(silver)
        } else if (gameScene.Score >= 100) {
            let bronze = SKSpriteNode(imageNamed: "Bronze.png")
            bronze.setScale(0.64)
            bronze.position = CGPointMake(self.frame.size.width*0.588, self.frame.size.height*0.55)
            bronze.zPosition = 5
            self.addChild(bronze)
        }
        
        
        //buttons
        let music = SKSpriteNode(imageNamed: "Home.png")
        music.setScale(0.12)
        music.position = CGPointMake(self.frame.size.width*0.4125, self.frame.size.height*0.38)
        music.zPosition = 4
        music.name = "home"
        self.addChild(music)
        
        let gamecenter = SKSpriteNode(imageNamed: "GameCenter.png")
        gamecenter.setScale(0.12)
        gamecenter.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.38)
        gamecenter.zPosition = 4
        gamecenter.name = "gamecenter"
        self.addChild(gamecenter)
        
        let share = SKSpriteNode(imageNamed: "Share.png")
        share.setScale(0.12)
        share.position = CGPointMake(self.frame.size.width*0.5885, self.frame.size.height*0.383)
        share.zPosition = 4
        share.name = "share"
        self.addChild(share)
        
        let retry = SKSpriteNode(imageNamed: "Retry.png")
        retry.setScale(0.35)
        retry.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.25)
        retry.zPosition = 4
        retry.name = "retry"
        self.addChild(retry)
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch in (touches as! Set<UITouch>)  {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if (node.name == "retry") {
                BGMPlayerGO.stop()
                let originalGamePlay = GamePlay(size: self.size)
                originalGamePlay.scaleMode = .AspectFill
                self.view?.presentScene(originalGamePlay)
            } else if (node.name == "home") {
                BGMPlayerGO.stop()
                let homeGameScene = GameScene(size: self.size)
                homeGameScene.scaleMode = .AspectFill
                self.view?.presentScene(homeGameScene)
            } else if (node.name == "gamecenter") {
                NSNotificationCenter.defaultCenter().postNotificationName("GameCenterNotification", object: nil)
            } else if (node.name == "share") {
                NSNotificationCenter.defaultCenter().postNotificationName("ShareNotification", object: nil)
            }
        }
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
}







