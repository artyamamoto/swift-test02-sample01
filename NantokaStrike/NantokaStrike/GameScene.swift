//
//  GameScene.swift
//  NantokaStrike
//
//  Created by 山本和明 on 2014/10/08.
//  Copyright (c) 2014年 Kazuaki Yamamoto. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var arrow:SKSpriteNode
    var nantoka:SKSpriteNode
    
    var enemyLifeGuage: SKSpriteNode
    let enemyLifeGuageBase: SKSpriteNode
    
    
    var enemyLifePoint = 100
    
    let MYSELF: UInt32 = 1 << 0
    let ENEMY: UInt32 = 1 << 1
    
    
    required init(coder aDecoder:NSCoder) {
        fatalError("NSCoder not supported")
    }
    override init(size:CGSize) {
        println("\(size)")
        
        arrow = SKSpriteNode(imageNamed: "arrow")
        arrow.alpha = 1
        arrow.position = CGPoint(x: 160, y: 160)
        arrow.xScale = 0.2
        
        nantoka = SKSpriteNode(imageNamed: "nantoka")
        nantoka.size = CGSizeMake(40,40)
        nantoka.position = CGPoint(x: size.width / 2 , y: size.height / 2 )
        
        nantoka.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        nantoka.physicsBody?.dynamic = true
        
        nantoka.physicsBody?.usesPreciseCollisionDetection = true
        nantoka.physicsBody?.friction = 0
        
        enemyLifeGuage = SKSpriteNode(color: UIColor.yellowColor(), size: CGSizeMake(size.width, 20))
        enemyLifeGuage.position = CGPoint(x:0, y: size.height - enemyLifeGuage.size.height)
        enemyLifeGuage.anchorPoint = CGPoint(x:0, y:0)
        
        enemyLifeGuageBase = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(size.width, 20))
        enemyLifeGuageBase.position = CGPoint(x:0, y: size.height - enemyLifeGuageBase.size.height)
        enemyLifeGuageBase.anchorPoint = CGPoint(x:0, y:0)
        
        super.init(size: size)
        
        
        physicsWorld.contactDelegate = self
        
        nantoka.physicsBody?.categoryBitMask = MYSELF
        nantoka.physicsBody?.contactTestBitMask = ENEMY
        
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.position = CGPoint(x: size.width * 0.75, y: size.height * 0.75)
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(80,80))
        enemy.physicsBody?.dynamic = false
        enemy.physicsBody?.categoryBitMask = ENEMY
        enemy.physicsBody?.contactTestBitMask = MYSELF
        enemy.physicsBody?.usesPreciseCollisionDetection = true
        addChild(enemy)
        
        
        let wallThickness: CGFloat = 10
        let fieldSize = CGSizeMake(size.width - wallThickness * 2, 400)
        
        let fieldBottomY = size.height - (enemyLifeGuage.size.height + wallThickness + fieldSize.height)
        
        // upper
        addWall(CGSize(width:fieldSize.width, height: wallThickness),
            position: CGPoint(x:wallThickness, y:enemyLifeGuage.position.y - wallThickness))
        
        // bottom
        addWall(CGSize(width:fieldSize.width, height: wallThickness),
            position: CGPoint(x:wallThickness, y: fieldBottomY - wallThickness))
        
        // right
        addWall(CGSize(width:wallThickness, height: fieldSize.height),
            position: CGPoint(x:wallThickness + fieldSize.width, y: fieldBottomY))
        
        // left
        addWall(CGSize(width:wallThickness, height: fieldSize.height),
            position: CGPoint(x:0, y: fieldBottomY))
        
        addChild(enemyLifeGuageBase)
        addChild(enemyLifeGuage)
        
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        
        backgroundColor = SKColor(red:0.9, green:0.9, blue:0.9, alpha:1.0)
        anchorPoint = CGPoint(x:0, y:0)
        
        addChild(arrow)
        addChild(nantoka)
    }
    func addWall(size: CGSize, position: CGPoint) {
        var wall:SKSpriteNode = SKSpriteNode(color: UIColor.brownColor(), size: size)
        wall.position = position
        wall.anchorPoint = CGPoint(x: 0, y:0)
        
        wall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(size.width * 2, size.height * 2))
        wall.physicsBody?.dynamic = false
        
        addChild(wall)
        
    }
    
    func turnArrow(angle: CGFloat, scale: CGFloat) {
        let rotateAction = SKAction.rotateByAngle(angle, duration: 0.1)
        let scaleAction = SKAction.scaleXTo(scale, y:1, duration: 0.1)
        
        arrow.runAction(SKAction.group([rotateAction, scaleAction]))
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        println("didBeginContact")
        let (starBody, other) = (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ?
            (contact.bodyA, contact.bodyB) :
            (contact.bodyB, contact.bodyA))
        
        switch other.categoryBitMask {
        case ENEMY:
            enemyLifePoint -= 10
            enemyLifeGuage.size = CGSizeMake(
                enemyLifeGuageBase.size.width * CGFloat(enemyLifePoint) / CGFloat(100.0),
                enemyLifeGuageBase.size.height)
        default:
            break
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
