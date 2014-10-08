//
//  GameViewController.swift
//  Puzzle01
//
//  Created by 山本和明 on 2014/10/01.
//  Copyright (c) 2014年 Kazuaki Yamamoto. All rights reserved.
//

import UIKit
import SpriteKit
/*
extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)!
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
} */

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    var scene:GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    /*
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            // return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            // return Int(UIInterfaceOrientationMask.All.toRaw())
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    } */
/*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    } */


    @IBAction func didTap(sender: UITapGestureRecognizer) {
        let location = sender.locationInView(view)
        println("tapped at \(location.x), \(location.y)")
        
        scene!.didTap(location)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
