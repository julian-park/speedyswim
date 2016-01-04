//
//  GameViewController.swift
//  Swimming
//
//  Created by Joonyon Park on 5/2/15.
//  Copyright (c) 2015 Julian Joonyon Park. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var leaderscore = NSUserDefaults.standardUserDefaults().valueForKey("Highscore") as! NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
        
        authenticateLocalPlayer()
        
        //Banner.hidden = true
        //Banner.delegate = self
        //self.canDisplayBannerAds = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLeaderboard", name: "GameCenterNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showShare", name: "ShareNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("myObserverMethod:"), name:UIApplicationDidEnterBackgroundNotification, object: nil)

    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    
    func showLeaderboard() {
        saveHighscore(leaderscore)
        showLeader()
    }
    
    //send high score to leaderboard
    func saveHighscore(leaderscore:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "speedyswimleaderboard") //leaderboard id here
            scoreReporter.value = Int64(leaderscore) //score variable here (same as above)
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: { (error:NSError?) -> Void in
                if error != nil {
                    print("error")
                }
            })
        }
    }
    
    
    //shows leaderboard screen
    func showLeader() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //initiate gamecenter
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }
            else {
                print((GKLocalPlayer.localPlayer().authenticated))
            }
        }
    }
    
    
    func showShare() {
        let myText = "Hey, I speedy swam " + "\(leaderscore)m! fb.com/SpeedySwim"
        let shareVC:UIActivityViewController = UIActivityViewController(activityItems: [myText], applicationActivities: nil)
        
        self.presentViewController(shareVC, animated: true, completion: nil)
    }
    

    
    func myObserverMethod(notification : NSNotification) {
        println("Observer method called")
        GamePlay().pauseGame()

        //You may call your action method here, when the application did enter background.
        //ie., self.pauseTimer() in your case.
    }
}
