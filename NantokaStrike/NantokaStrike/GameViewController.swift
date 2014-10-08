//
//  GameViewController.swift
//  NantokaStrike
//
//  Created by 山本和明 on 2014/10/08.
//  Copyright (c) 2014年 Kazuaki Yamamoto. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    var scene:GameScene!
    var panPointReference: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.showsPhysics = true
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translationInView(self.view)
        if let originalPoint = panPointReference {
            println("currentPoint: \(currentPoint)")
            
            let v = sub(currentPoint, p1: originalPoint)
            let len = length(v)
            
            scene.arrow.alpha = 1
            scene.arrow.position = scene.nantoka.position
            
            let scale = 0.2 * len / CGFloat(5.0)
            scene.turnArrow(angle(v), scale: scale)
        } else if sender.state == .Began {
            println(".Began")
            panPointReference = currentPoint
        }
        if sender.state == .Ended {
            println(".Ended")
            scene.nantoka.physicsBody?.velocity = acceleration(currentPoint, p: panPointReference!)
            
            panPointReference = nil
            scene.arrow.alpha = 0
        }
    }
    
    func acceleration(o: CGPoint, p: CGPoint)->CGVector {
        let leverage = CGFloat(50)
        return CGVectorMake(leverage * (p.x - o.x), leverage * (o.y - p.y))
    }
    //=== ベクトルの計算
    func sub(p0: CGPoint, p1: CGPoint)->CGPoint {
        return CGPoint(x: p0.x - p1.x, y:p0.y - p1.y)
    }
    func length(v: CGPoint)->CGFloat {
        return sqrt(v.x * v.x + v.y * v.y)
    }
    func angle(v: CGPoint)->CGFloat {
        let len = length(v)
        let c = v.x / len
        if v.x == 0 {
            return acos(c)
        } else {
            let t = -v.y / v.x
            let a = CGFloat(atan(t))
            return a + CGFloat(0 < v.x ? M_PI : 0.0)
        }
    }
}


