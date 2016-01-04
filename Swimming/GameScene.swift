//
//  GameScene.swift
//  Swimming
//
//  Created by Joonyon Park on 5/2/15.
//  Copyright (c) 2015 Julian Joonyon Park. All rights reserved.
//

/*let flagImage = SKSpriteNode(imageNamed: "Flags.png")
backgroundImage.setScale(0.6)
backgroundImage.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height)
backgroundImage.zPosition = 2.5
let scrollFlag = SKAction.moveToY(-50, duration: 1)
let scrollFlagDone = SKAction.waitForDuration(10)
let scrollFlagReturn = SKAction.moveToY(self.frame.size.height, duration: 0)
backgroundImage.runAction(SKAction.repeatActionForever(SKAction.sequence([scrollFlag,scrollFlagDone,scrollFlagReturn])))
self.addChild(backgroundImage)*/


import UIKit
import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Player = SKSpriteNode(imageNamed: "Player1.png")
    var BGMPlayerGS = AVAudioPlayer(contentsOfURL:NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("BGM", ofType: "mp3")!), error: nil)
    
    var SoundValue = Int()
    var slash = SKSpriteNode(imageNamed: "SlashBar.png")
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        
        BGMPlayerGS.play()
        BGMPlayerGS.volume = 0.4
        BGMPlayerGS.numberOfLoops = -1
        
        let SoundDefault = NSUserDefaults.standardUserDefaults()
        if (SoundDefault.valueForKey("SoundValue") != nil) {
            SoundValue = SoundDefault.valueForKey("SoundValue") as! NSInteger!
            //highScoreLbl.text = "\(gameScene.Highscore)" + "m"
            
            BGMPlayerGS.volume = 0
        }
        
        let backgroundImage = SKSpriteNode(imageNamed: "Pool.png")
        backgroundImage.setScale(0.6)
        backgroundImage.zPosition = -1
        backgroundImage.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        
        let scroll = SKAction.moveToY(180, duration: 1)
        let scrollDone = SKAction.moveTo(CGPointMake(self.frame.size.width / 2, self.frame.size.height / 1.82), duration: 0)
        backgroundImage.runAction(SKAction.repeatActionForever(SKAction.sequence([scroll,scrollDone])))
        self.addChild(backgroundImage)
        
        Player.setScale(0.3)
        Player.position = CGPointMake(self.size.width / 2 , self.size.height / 3.4)
        Player.zPosition = 1
        Player.physicsBody = SKPhysicsBody(rectangleOfSize: Player.size)
        Player.physicsBody?.affectedByGravity = false
        Player.physicsBody?.allowsRotation = false
        Player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        Player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        Player.physicsBody?.dynamic = false
        
        
        let playerTexture1 = SKTexture(imageNamed: "Player1.png")
        let playerTexture2 = SKTexture(imageNamed: "Player2.png")
        let action = SKAction.animateWithTextures([playerTexture1, playerTexture2], timePerFrame: 0.3)
        Player.runAction(SKAction.repeatActionForever(action))
        self.addChild(Player)
        
        let menu = SKSpriteNode(imageNamed: "Menu.png")
        menu.setScale(0.6)
        menu.position = CGPointMake(self.frame.size.width*0.502, self.frame.size.height*0.75)
        menu.zPosition = 3
        self.addChild(menu)
        
        /*let wall = SKSpriteNode(imageNamed: "Wall.png")
        wall.setScale(0.47)
        wall.zPosition = 2
        wall.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 30)
        self.addChild(wall)*/
        
        
        
        //buttons
        
        //If SoundDefault is not nil, no sound. If SoundDefault is nil, there is sound.
        let music = SKSpriteNode(imageNamed: "Music.png")
        music.setScale(0.15)
        music.position = CGPointMake(self.frame.size.width*0.4115, self.frame.size.height*0.52)
        music.zPosition = 4
        music.name = "music"
        self.addChild(music)
        
        if (SoundDefault.valueForKey("SoundValue") != nil) {
            slash.setScale(0.15)
            slash.position = CGPointMake(self.frame.size.width*0.414, self.frame.size.height*0.518)
            slash.zPosition = 4.1
            slash.name = "slash"
            self.addChild(slash)
        }
        
        let rate = SKSpriteNode(imageNamed: "Rate.png")
        rate.setScale(0.12)
        rate.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.522)
        rate.zPosition = 4
        rate.name = "rate"
        self.addChild(rate)
        
        let info = SKSpriteNode(imageNamed: "Info.png")
        info.setScale(0.1)
        info.position = CGPointMake(self.frame.size.width*0.5885, self.frame.size.height*0.52)
        info.zPosition = 4
        info.name = "info"
        self.addChild(info)
        
        let start = SKSpriteNode(imageNamed: "Start.png")
        start.setScale(0.6)
        start.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.42)
        start.zPosition = 4
        start.name = "start"
        self.addChild(start)
        
        
        let gamePlay = GamePlay(size: self.size)
        gamePlay.homeScene = self
        
    }
    
    
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>)  {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if (node.name == "info") {
                BGMPlayerGS.stop()
                let theInfoPage = InfoPage(size: self.size)
                theInfoPage.scaleMode = .AspectFill
                self.view?.presentScene(theInfoPage)
            } else if (node.name == "music" || node.name == "slash") {
                let SoundDefault = NSUserDefaults.standardUserDefaults()
                if (SoundDefault.valueForKey("SoundValue") == nil) {
                    BGMPlayerGS.stop()
                    slash.setScale(0.15)
                    slash.position = CGPointMake(self.frame.size.width*0.414, self.frame.size.height*0.518)
                    slash.zPosition = 4.1
                    slash.name = "slash"
                    self.addChild(slash)
                    
                    let SoundDefault = NSUserDefaults.standardUserDefaults()
                    SoundDefault.setValue(1, forKey: "SoundValue")
                    SoundDefault.synchronize()
                    
                } else if (SoundDefault.valueForKey("SoundValue") != nil) {
                    BGMPlayerGS.play()
                    BGMPlayerGS.volume = 0.3
                    BGMPlayerGS.numberOfLoops = -1
                    slash.removeFromParent()
                    
                    let SoundDefault = NSUserDefaults.standardUserDefaults()
                    SoundDefault.setValue(nil, forKey: "SoundValue")
                    SoundDefault.synchronize()
                }
            } else if (node.name == "rate") {
                UIApplication.sharedApplication().openURL(NSURL(string:"itms-apps://itunes.apple.com/app/id1011323516")!)
            } else if (node.name == "start") {
                BGMPlayerGS.stop()
                let gamePlay = GamePlay(size: self.size)
                gamePlay.scaleMode = .AspectFill
                self.view?.presentScene(gamePlay)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
}
