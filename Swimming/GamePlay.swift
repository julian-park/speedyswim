//
//  GamePlay.swift
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
import GameKit

struct PhysicsCategory {
    static let Enemy: UInt32 = 1  //0000000000000000000000001
    static let Player: UInt32 = 2 //0000000000000000000000010
    static let sideWall: UInt32 = 3
    static let blackO2: UInt32 = 4
    static let O2: UInt32 = 5
}

class GamePlay: SKScene, SKPhysicsContactDelegate {
    
    var error: NSError?

    var BGMPlayerGPURL = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("BGM", ofType: "mp3")!)
    var BGMPlayerGP = AVAudioPlayer()
    var StartURL = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Start", ofType: "mp3")!)
    var Start = AVAudioPlayer()
    var SwitchLane1URL = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Switch", ofType: "mp3")!)
    var SwitchLane1 = AVAudioPlayer()
    var SwitchLane2URL = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Switch", ofType: "mp3")!)
    var SwitchLane2 = AVAudioPlayer()
    var CrashURL = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Crash", ofType: "mp3")!)
    var Crash = AVAudioPlayer()
    var GainO2URL = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("GainO2", ofType: "mp3")!)
    var GainO2 = AVAudioPlayer()
    var LostO2URL = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("LostO2", ofType: "mp3")!)
    var LostO2 = AVAudioPlayer()
    
    /*var BGMPlayerGP = AVAudioPlayer(contentsOfURL:NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("BGM", ofType: "mp3")!), error: nil)
    var Start = AVAudioPlayer(contentsOfURL:NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Start", ofType: "mp3")!), error: nil)
    var SwitchLane1 = AVAudioPlayer(contentsOfURL:NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Switch", ofType: "mp3")!), error: nil)
    var SwitchLane2 = AVAudioPlayer(contentsOfURL:NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Switch", ofType: "mp3")!), error: nil)
    var Crash = AVAudioPlayer(contentsOfURL:NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Crash", ofType: "mp3")!), error: nil)
    var GainO2 = AVAudioPlayer(contentsOfURL:NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("GainO2", ofType: "mp3")!), error: nil)
    var LostO2 = AVAudioPlayer(contentsOfURL:NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("LostO2", ofType: "mp3")!), error: nil)*/
    
    var Player = SKSpriteNode(imageNamed: "Player1.png")
    var ScoreTimer = NSTimer()
    var Score = Int()
    var Highscore = Int()
    var ScoreLbl = SKLabelNode()
    var highScoreLbl = SKLabelNode()
    
    var sideWall = SKSpriteNode(imageNamed: "SideWall.png")
    var healthbar = SKSpriteNode(imageNamed: "WhiteHealthBar.png")
    var blackO2 = SKSpriteNode(imageNamed: "WhiteBlackO2.png")
    var fakeblackO2 = SKSpriteNode(imageNamed: "WhiteBlackO2.png")
    
    var homeScene = GameScene()
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        
        BGMPlayerGP = AVAudioPlayer(contentsOfURL: BGMPlayerGPURL, error: &error)
        Start = AVAudioPlayer(contentsOfURL: StartURL, error: &error)
        SwitchLane1 = AVAudioPlayer(contentsOfURL: SwitchLane1URL, error: &error)
        SwitchLane2 = AVAudioPlayer(contentsOfURL: SwitchLane2URL, error: &error)
        Crash = AVAudioPlayer(contentsOfURL: CrashURL, error: &error)
        GainO2 = AVAudioPlayer(contentsOfURL: GainO2URL, error: &error)
        LostO2 = AVAudioPlayer(contentsOfURL: LostO2URL, error: &error)

        Start.play()
        SwitchLane1.enableRate = true
        SwitchLane1.volume = 1
        SwitchLane1.rate = 13
        SwitchLane2.enableRate = true
        SwitchLane2.volume = 1
        SwitchLane2.rate = 13
        Crash.volume = 2
        
        BGMPlayerGP.play()
        BGMPlayerGP.volume = 0.4
        BGMPlayerGP.numberOfLoops = -1
        
        
        //If SoundDefault is not nil, no sound. If SoundDefault is nil, there is sound.
        let SoundDefault = NSUserDefaults.standardUserDefaults()
        if (SoundDefault.valueForKey("SoundValue") != nil) {
            homeScene.SoundValue = SoundDefault.valueForKey("SoundValue") as! NSInteger!
            //highScoreLbl.text = "\(gameScene.Highscore)" + "m"
            
            BGMPlayerGP.volume = 0
            Start.volume = 0
            SwitchLane1.volume = 0
            SwitchLane2.volume = 0
            Crash.volume = 0
            GainO2.volume = 0
            LostO2.volume = 0
            
        }
        
        let backgroundImage = SKSpriteNode(imageNamed: "Pool.png")
        backgroundImage.setScale(0.6)
        backgroundImage.zPosition = -1
        backgroundImage.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        let scroll = SKAction.moveToY(180, duration: 1)
        let scrollDone = SKAction.moveTo(CGPointMake(self.frame.size.width / 2, self.frame.size.height / 1.82), duration: 0)
        backgroundImage.runAction(SKAction.repeatActionForever(SKAction.sequence([scroll,scrollDone])))
        self.addChild(backgroundImage)
        
        sideWall.setScale(0.9)
        sideWall.position = CGPointMake(self.frame.size.width*0.242, self.frame.size.height*1.05)
        sideWall.zPosition = 5
        sideWall.physicsBody = SKPhysicsBody(rectangleOfSize: sideWall.size)
        sideWall.physicsBody?.categoryBitMask = PhysicsCategory.sideWall
        sideWall.physicsBody?.contactTestBitMask = PhysicsCategory.blackO2
        sideWall.physicsBody?.affectedByGravity = false
        sideWall.physicsBody?.allowsRotation = false
        sideWall.physicsBody?.dynamic = true
        self.addChild(sideWall)
        
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
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("scoreTime"), userInfo: nil, repeats: true)
        
        NSTimer.scheduledTimerWithTimeInterval(0.62, target: self, selector: Selector("SpawnEnemies1"), userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(0.62, target: self, selector: Selector("SpawnEnemies2"), userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(0.62, target: self, selector: Selector("SpawnEnemies3"), userInfo: nil, repeats: true)
        
        NSTimer.scheduledTimerWithTimeInterval(0.31, target: self, selector: Selector("LagTimeO2"), userInfo: nil, repeats: false)
        
        ScoreLbl = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        ScoreLbl.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.87)
        ScoreLbl.fontColor = UIColor.blackColor()
        ScoreLbl.fontSize = 45
        ScoreLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        ScoreLbl.zPosition = 4
        self.addChild(ScoreLbl)
        
        
        FunctionO2()
        
        let HighscoreDefault = NSUserDefaults.standardUserDefaults()
        if (HighscoreDefault.valueForKey("Highscore") != nil) {
            Highscore = HighscoreDefault.valueForKey("Highscore") as! NSInteger!
            //highScoreLbl.text = NSString(format: "Highscore : %i", Highscore) as String
        }
        
    }

    func pauseGame() {
        println("game paused")

        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.scaleMode = .AspectFill
        gameOverScene.gameScene = self
        self.view?.presentScene(gameOverScene)
    }
    
    func FunctionO2() {
        

        healthbar.setScale(0.75)
        healthbar.position = CGPointMake(self.frame.size.width*0.45, self.frame.size.height*0.98)
        healthbar.zPosition = 4
        let barSlide = SKAction.moveToX(-150, duration: 40)
        healthbar.runAction(barSlide)
        self.addChild(healthbar)
        
        blackO2.setScale(0.3)
        blackO2.position = CGPointMake(self.frame.size.width*0.681, self.frame.size.height*1.1)
        blackO2.zPosition = 4.1
        blackO2.physicsBody = SKPhysicsBody(rectangleOfSize: blackO2.size)
        blackO2.physicsBody?.categoryBitMask = PhysicsCategory.blackO2
        blackO2.physicsBody?.contactTestBitMask = PhysicsCategory.sideWall
        blackO2.physicsBody?.affectedByGravity = false
        blackO2.physicsBody?.allowsRotation = false
        blackO2.physicsBody?.dynamic = true
        let blackO2Slide = SKAction.moveToX(-100, duration: 52)
        blackO2.runAction(blackO2Slide)
        self.addChild(blackO2)
        
        fakeblackO2.setScale(0.3)
        fakeblackO2.position = CGPointMake(self.frame.size.width*0.681, self.frame.size.height*0.97)
        fakeblackO2.zPosition = 4.2
        let fakeblackO2Slide = SKAction.moveToX(-100, duration: 52)
        fakeblackO2.runAction(fakeblackO2Slide)
        self.addChild(fakeblackO2)
    }
    
    
    func SpawnEnemies1(){
        let Enemy = SKSpriteNode(imageNamed: "Enemy1.png")
        Enemy.zPosition = 1
        
        enum SpawnPoint: UInt32 {
            case Lane1
            case Lane4
            
            static func randomLane() -> SpawnPoint {
                // find the maximum enum value
                var maxValue: UInt32 = 0
                while let _ = self(rawValue: ++maxValue) {}
                
                // pick and return a new value
                let rand = arc4random_uniform(maxValue)
                return self(rawValue: rand)!
            }
        }
        
        switch SpawnPoint.randomLane() {
            
        case .Lane1:
            Enemy.position = CGPointMake(self.frame.size.width*0.325, self.frame.size.height)
            let action = SKAction.moveToY(-70, duration: 1.7)
            let actionDone = SKAction.removeFromParent()
            Enemy.runAction(SKAction.sequence([action, actionDone]))
        case .Lane4:
            Enemy.position = CGPointMake(self.frame.size.width*0.588, self.frame.size.height)
            let action = SKAction.moveToY(-70, duration: 1.7)
            let actionDone = SKAction.removeFromParent()
            Enemy.runAction(SKAction.sequence([action, actionDone]))
        }
        
        Enemy.setScale(0.3)
        Enemy.physicsBody = SKPhysicsBody(rectangleOfSize: Enemy.size)
        Enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        Enemy.physicsBody?.affectedByGravity = false
        Enemy.physicsBody?.allowsRotation = false
        Enemy.physicsBody?.dynamic = true
        
        let enemyTexture1 = SKTexture(imageNamed: "Enemy1.png")
        let enemyTexture2 = SKTexture(imageNamed: "Enemy2.png")
        let animate = SKAction.animateWithTextures([enemyTexture1, enemyTexture2], timePerFrame: 0.3)
        Enemy.runAction(SKAction.repeatActionForever(animate))
        
        self.addChild(Enemy)
    }
    
    func SpawnEnemies2(){
        let Enemy = SKSpriteNode(imageNamed: "Enemy1.png")
        Enemy.zPosition = 1
        
        enum SpawnPoint: UInt32 {
            case Lane2
            case Lane5
            
            static func randomLane() -> SpawnPoint {
                // find the maximum enum value
                var maxValue: UInt32 = 0
                while let _ = self(rawValue: ++maxValue) {}
                
                // pick and return a new value
                let rand = arc4random_uniform(maxValue)
                return self(rawValue: rand)!
            }
        }
        
        switch SpawnPoint.randomLane() {
            
        case .Lane2:
            Enemy.position = CGPointMake(self.frame.size.width*0.413, self.frame.size.height)
            let action = SKAction.moveToY(-70, duration: 1.7)
            let actionDone = SKAction.removeFromParent()
            Enemy.runAction(SKAction.sequence([action, actionDone]))
        case .Lane5:
            Enemy.position = CGPointMake(self.frame.size.width*0.675, self.frame.size.height)
            let action = SKAction.moveToY(-70, duration: 1.7)
            let actionDone = SKAction.removeFromParent()
            Enemy.runAction(SKAction.sequence([action, actionDone]))
        }
        
        Enemy.setScale(0.3)
        Enemy.physicsBody = SKPhysicsBody(rectangleOfSize: Enemy.size)
        Enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        Enemy.physicsBody?.affectedByGravity = false
        Enemy.physicsBody?.dynamic = true
        
        let enemyTexture1 = SKTexture(imageNamed: "Enemy1.png")
        let enemyTexture2 = SKTexture(imageNamed: "Enemy2.png")
        let animate = SKAction.animateWithTextures([enemyTexture1, enemyTexture2], timePerFrame: 0.3)
        Enemy.runAction(SKAction.repeatActionForever(animate))
        
        self.addChild(Enemy)
    }
    
    func SpawnEnemies3(){
        let Enemy = SKSpriteNode(imageNamed: "Enemy1.png")
        Enemy.zPosition = 1
        
        enum SpawnPoint: UInt32 {
            case Lane3
            case Lane6
            
            static func randomLane() -> SpawnPoint {
                // find the maximum enum value
                var maxValue: UInt32 = 0
                while let _ = self(rawValue: ++maxValue) {}
                
                // pick and return a new value
                let rand = arc4random_uniform(maxValue)
                return self(rawValue: rand)!
            }
        }
        
        switch SpawnPoint.randomLane() {
            
        case .Lane3:
            Enemy.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height)
            let action = SKAction.moveToY(-70, duration: 1.7)
            let actionDone = SKAction.removeFromParent()
            Enemy.runAction(SKAction.sequence([action, actionDone]))
        case .Lane6:
            let action = SKAction.moveToY(-70, duration: 1.7)
            let actionDone = SKAction.removeFromParent()
            Enemy.runAction(SKAction.sequence([action, actionDone]))
        }
        
        Enemy.setScale(0.3)
        Enemy.physicsBody = SKPhysicsBody(rectangleOfSize: Enemy.size)
        Enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        Enemy.physicsBody?.affectedByGravity = false
        Enemy.physicsBody?.dynamic = true
        
        let enemyTexture1 = SKTexture(imageNamed: "Enemy1.png")
        let enemyTexture2 = SKTexture(imageNamed: "Enemy2.png")
        let animate = SKAction.animateWithTextures([enemyTexture1, enemyTexture2], timePerFrame: 0.3)
        Enemy.runAction(SKAction.repeatActionForever(animate))
        
        self.addChild(Enemy)
        
    }
    
    
    func LagTimeO2(){
        NSTimer.scheduledTimerWithTimeInterval(6.2, target: self, selector: Selector("SpawnO2"), userInfo: nil, repeats: true)
    }
    
    func SpawnO2(){
        let O2 = SKSpriteNode(imageNamed: "O2.png")
        O2.zPosition = 1
        
        enum SpawnPoint: UInt32 {
            case Lane1
            case Lane2
            case Lane3
            case Lane4
            case Lane5
            
            static func randomLane() -> SpawnPoint {
                // find the maximum enum value
                var maxValue: UInt32 = 0
                while let _ = self(rawValue: ++maxValue) {}
                
                // pick and return a new value
                let rand = arc4random_uniform(maxValue)
                return self(rawValue: rand)!
            }
        }
        
        switch SpawnPoint.randomLane() {
            
        case .Lane1:
            O2.position = CGPointMake(self.frame.size.width*0.325, self.frame.size.height)
            let action = SKAction.moveToY(-70, duration: 1.7)
            let actionDone = SKAction.removeFromParent()
            O2.runAction(SKAction.sequence([action, actionDone]))
        case .Lane2:
            O2.position = CGPointMake(self.frame.size.width*0.413, self.frame.size.height)
            let action = SKAction.moveToY(-70, duration: 1.7)
            let actionDone = SKAction.removeFromParent()
            O2.runAction(SKAction.sequence([action, actionDone]))
        case .Lane3:
            O2.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height)
            let action = SKAction.moveToY(-70, duration: 1.7)
            let actionDone = SKAction.removeFromParent()
            O2.runAction(SKAction.sequence([action, actionDone]))
        case .Lane4:
            O2.position = CGPointMake(self.frame.size.width*0.588, self.frame.size.height)
            let action = SKAction.moveToY(-70, duration: 1.7)
            let actionDone = SKAction.removeFromParent()
            O2.runAction(SKAction.sequence([action, actionDone]))
        case .Lane5:
            O2.position = CGPointMake(self.frame.size.width*0.675, self.frame.size.height)
            let action = SKAction.moveToY(-70, duration: 1.7)
            let actionDone = SKAction.removeFromParent()
            O2.runAction(SKAction.sequence([action, actionDone]))
        }
        
        O2.setScale(0.3)
        O2.physicsBody = SKPhysicsBody(rectangleOfSize: O2.size)
        O2.physicsBody?.categoryBitMask = PhysicsCategory.O2
        O2.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        O2.physicsBody?.affectedByGravity = false
        O2.physicsBody?.allowsRotation = false
        O2.physicsBody?.dynamic = true
        
        self.addChild(O2)
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB
        let thirdBody : SKPhysicsBody = contact.bodyA
        let fourthBody : SKPhysicsBody = contact.bodyB
        let fifthBody : SKPhysicsBody = contact.bodyA
        let sixthBody : SKPhysicsBody = contact.bodyB
        
        
        if((firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Player) ||
            (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Enemy)){
                Crash.play()
                CollisionWithPlayer(firstBody.node as! SKSpriteNode, Player: secondBody.node as! SKSpriteNode)
        }
        
        if((thirdBody.categoryBitMask == PhysicsCategory.sideWall) && (fourthBody.categoryBitMask == PhysicsCategory.blackO2) ||
            (thirdBody.categoryBitMask == PhysicsCategory.blackO2) && (fourthBody.categoryBitMask == PhysicsCategory.sideWall)){
                LostO2.play()
                CollisionWithWall(thirdBody.node as! SKSpriteNode, blackO2: fourthBody.node as! SKSpriteNode)
        }
        
        if((fifthBody.categoryBitMask == PhysicsCategory.O2) && (sixthBody.categoryBitMask == PhysicsCategory.Player) ||
            (fifthBody.categoryBitMask == PhysicsCategory.Player) && (sixthBody.categoryBitMask == PhysicsCategory.O2)){
                GainO2.play()
                CollisionWithO2(fifthBody.node as! SKSpriteNode, Player: sixthBody.node as! SKSpriteNode)
        }
    }
    
    func CollisionWithPlayer(Enemy: SKSpriteNode, Player: SKSpriteNode){
        //VIBRATION: AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);

        sleep(1)
        
        if (Score > Highscore) {
            Highscore = Score
            let HighscoreDefault = NSUserDefaults.standardUserDefaults()
            HighscoreDefault.setValue(Highscore, forKey: "Highscore")
            HighscoreDefault.synchronize()
        }
        
        Enemy.removeFromParent()
        Player.removeFromParent()
        ScoreLbl.removeFromParent()
        ScoreTimer.invalidate()
        
        BGMPlayerGP.stop()
        
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.scaleMode = .AspectFill
        gameOverScene.gameScene = self
        //gameOverScene.Score = Score
        //gameOverScene.Highscore = Highscore
        self.view?.presentScene(gameOverScene)
        
    }
    
    func CollisionWithWall(sideWall: SKSpriteNode, blackO2: SKSpriteNode){
        //AudioToolbox VIBRATION: AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
        
        sleep(1)
        
        if (Score > Highscore) {
            Highscore = Score
            let HighscoreDefault = NSUserDefaults.standardUserDefaults()
            HighscoreDefault.setValue(Highscore, forKey: "Highscore")
            HighscoreDefault.synchronize()
        }
        
        blackO2.removeFromParent()
        sideWall.removeFromParent()
        ScoreLbl.removeFromParent()
        ScoreTimer.invalidate()
        
        BGMPlayerGP.stop()
        
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.scaleMode = .AspectFill
        gameOverScene.gameScene = self
        //gameOverScene.Score = Score
        //gameOverScene.Highscore = Highscore
        self.view?.presentScene(gameOverScene)
        
    }
    
    
    func CollisionWithO2(O2: SKSpriteNode, Player: SKSpriteNode){
        
        Player.removeFromParent()
        
        let barReset = SKAction.moveToX(self.frame.size.width*0.45, duration: 0)
        healthbar.runAction(barReset)
        let blackO2Reset = SKAction.moveToX(self.frame.size.width*0.681, duration: 0)
        blackO2.runAction(blackO2Reset)
        let fakeblackO2Reset = SKAction.moveToX(self.frame.size.width*0.681, duration: 0)
        fakeblackO2.runAction(fakeblackO2Reset)
        
        let barSlide = SKAction.moveToX(-150, duration: 40)
        healthbar.runAction(barSlide)
        let blackO2Slide = SKAction.moveToX(-100, duration: 52)
        blackO2.runAction(blackO2Slide)
        let fakeblackO2Slide = SKAction.moveToX(-100, duration: 52)
        fakeblackO2.runAction(fakeblackO2Slide)
    }
    

    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        let leftBorder = self.frame.size.width*0.35
        let rightBorder = self.frame.size.width*0.65
        
        for touch in (touches as! Set<UITouch>)  {
            let location = touch.locationInNode(self)
            
            if location.x > self.frame.size.width*0.5 {
                let moveRight = SKAction.moveByX(self.frame.size.width*0.088, y:0, duration:0)
                if Player.position.x < CGFloat(rightBorder) {
                    Player.runAction(moveRight)
                    SwitchLane1.play()
                }
            } else if location.x < self.frame.size.width*0.5 {
                let moveLeft = SKAction.moveByX(-self.frame.size.width*0.088, y:0, duration:0)
                if Player.position.x > CGFloat(leftBorder) {
                    Player.runAction(moveLeft)
                    SwitchLane2.play()
                }
            }
        }
    }
    
    func scoreTime(){
        Score++
        ScoreLbl.text = "\(Score)" + "m"
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}