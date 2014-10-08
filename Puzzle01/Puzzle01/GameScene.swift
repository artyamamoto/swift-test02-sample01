//
//  GameScene.swift
//  Puzzle01
//
//  Created by 山本和明 on 2014/10/01.
//  Copyright (c) 2014年 Kazuaki Yamamoto. All rights reserved.
//

import SpriteKit


// struct だとインスタンスが参照にならないため、オブジェクトにする。
class Block {
    var num = 0
    var label:SKLabelNode?
    var rect:SKShapeNode?
    var checked = false
    
    init(num:Int, label:SKLabelNode?=nil,rect:SKShapeNode?=nil, checked:Bool=false) {
        self.num = num
        self.label = label
        self.rect = rect
        self.checked = checked
    }
}
class GameTimer {
    var start_t:Double = 0
    var end_t:Double = 0
    
    func time()->Double {
        let date = NSDate()
        var t = date.timeIntervalSince1970
        return t
    }
    func reset() {
        start_t = 0.0
        end_t = 0.0
    }
    func start() {
        start_t = time()
    }
    func stop() {
        end_t = time()
    }
    func getFormat()->String {
        var t = end_t > 0 ? end_t : time()
            t = start_t > 0 ? t - start_t : 0
        
        var ss = Int(t) % 60
        var mm = Int(t / 60 ) % 60
        var hh = Int(t / 60 / 60)
        
        return NSString(format:"%02d:%02d:%02d", hh, mm, ss)
    }
}

class GameScene: SKScene {
    var blockSize:CGSize?
    var blockSideNum:Int = 4
    var padding:Float = 10
    var blocks:[Block] = []
    
    var nextNum:Int = 0
    
    var timer:GameTimer?
    var timerLabel:SKLabelNode?
    
//    var btnLabel:SKLabelNode?
//    var btnRect:SKShapeNode?
    
    var is_playing:Bool = false
    
    required init(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("NSCoder not supported")
    }
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 1.0, green:1.0, blue:1.0, alpha:1.0)
        anchorPoint = CGPoint(x: 0, y: 0)
        
        
        var size_:CGSize = CGSize(width: Int(self.size.width) - Int(padding) * 2, height:60)
        var pos_:CGPoint = CGPoint(x: CGFloat(self.size.width / 2), y: CGFloat(Float(self.size.height) - padding))
        /*
        btnRect = SKShapeNode(rectOfSize: size_)
        btnRect!.fillColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
        btnRect!.position = pos_
        btnRect!.hidden = true
        self.addChild(btnRect!)

        btnLabel = SKLabelNode(fontNamed:"Chalkduster")
        btnLabel!.fontSize = 32
        btnLabel!.position = CGPoint(x:0, y:0)
        btnLabel!.fontColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        btnLabel!.hidden = true
        self.addChild(btnLabel!) */
        
        is_playing = false
        
        
        timer = GameTimer()

        timerLabel = SKLabelNode(fontNamed:"Chalkduster")
        timerLabel!.fontSize = 32
        timerLabel!.position = CGPoint(x: 0, y: 0)
        timerLabel!.fontColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        self.addChild(timerLabel!)
        
        start()
    }
    func start() {
        timerLabel!.text = timer!.getFormat()
        timer!.start()
        initBlocks()
        
        is_playing = true
    }
    
    override func didMoveToView(view: SKView) {
        /*
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
            */
        drawBlocks()
    }
    func drawBlocks() {
        //=== ラベル
        /* if let size_ = self.blockSize {
            if let timer = timerLabel {
                var w0 = Float(size_.width)
                var h0 = Float(size_.height)
                
                var x0 = CGFloat(self.size.width / 2)
                var y0 = CGFloat(Float(timerLabel!.position.y) - padding - 40)
                
                // y0 = CGFloat(self.size.height) - y0
                
                btnLabel!.position = CGPoint(x: x0, y: y0)
                btnLabel!.hidden = (is_playing == false)
                btnRect!.position = CGPoint(x: x0, y: y0 + 30)
                btnRect!.hidden = (is_playing == false)
            }
        }
        
        btnLabel!.text = (is_playing ? "" : "CLEAR")
        */
        
        /* if is_playing == false{
            return
        } */
        
        culcSize()
        for (var y=0; y<self.blockSideNum; y++) {
            for (var x=0; x<self.blockSideNum; x++) {
                var block = self.blocks[y * self.blockSideNum + x]
                
                if let size_ = self.blockSize {
                    var w0 = Float(size_.width)
                    var h0 = Float(size_.height)
                    var x_ = Float(x)
                    var y_ = Float(y)
                    var x0 = CGFloat(padding * (x_ + 1) + w0 * (x_ + 0.5))
                    var y0 = CGFloat(padding * (y_ + 1) + h0 * (y_ + 0.5))
                    
                    y0 = CGFloat(self.size.height) - y0
                    
                    var color_ = block.checked ?
                            UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5) :
                            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    
                    if let rect = block.rect {
                        rect.position = CGPoint(x: x0, y: y0)
                    } else {
                        var r_ = CGFloat(Float((arc4random() % 100) + 127.0)/255.0)
                        var g_ = CGFloat(Float((arc4random() % 100) + 127.0)/255.0)
                        var b_ = CGFloat(Float((arc4random() % 100) + 127.0)/255.0)
                        
                        var rect_ = SKShapeNode(rectOfSize: size_)
                        rect_.fillColor = UIColor(red: r_, green: g_, blue: b_, alpha: 1.0)
                        rect_.position = CGPoint(x: x0, y: y0)
                        
                        self.addChild(rect_)
                        block.rect = rect_
                    }
                    
                    
                    if let label = block.label {
                        label.text = String(block.num)
                        label.position = CGPoint(x: x0, y: y0)
                        label.fontColor = color_
                    } else {
                        var label_ = SKLabelNode(fontNamed:"Chalkduster")
                        label_.text = String(block.num)
                        label_.fontSize = 32
                        label_.position = CGPoint(x: x0, y: y0)
                        label_.fontColor = color_
                        
                        self.addChild(label_)
                        
                        block.label = label_
                    }
                }
                
            }
        }
        
        if let size_ = self.blockSize {
            if let timer = timerLabel {
                var w0 = Float(size_.width)
                var h0 = Float(size_.height)
                
                var x0 = CGFloat(self.size.width / 2)
                var y0 = CGFloat(padding * (4 + 1) + h0 * (4 + 0.5))
                
                y0 = CGFloat(self.size.height) - y0
                
                timerLabel!.position = CGPoint(x: x0, y: y0)
            }
        }
    }
    func initBlocks() {
        self.blocks = []
        for (var y=0; y<self.blockSideNum; y++) {
            for (var x=0; x<self.blockSideNum; x++) {
                self.blocks.append(Block( num: y * 4 + x + 1 ))
            }
        }
        // 乱数
        var len = Int(self.blocks.count)
        if len > 0 {
            for (var i=100; i>0; i--) {
                var n1 = Int(arc4random()) % len
                var n2 = Int(arc4random()) % len
                
                if (n1 != n2) {
                    var tmp = self.blocks[n1]
                    self.blocks[n1] = self.blocks[n2]
                    self.blocks[n2] = tmp
                }
            }
        }
        // next num
        nextNum = 1
    }
    func culcSize() {
        var s:CGSize = self.size
        
        var num:Float = Float(self.blockSideNum)
        var w:Int = Int((Float(s.width) - padding * (num + 1)) / num)
        var maxH:Int = Int((Float(s.height) - padding * (num + 1)) / num)
        
        var h:Int = (maxH > w ? w : maxH)
        self.blockSize = CGSize(width:w, height:h)
    }
    /*
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            drawBlocks()
        }
    } */
    
    func didTap(location:CGPoint) {
        var x = Float(location.x)
        var y = Float(location.y)
        
        if is_playing == false {
            /* if let rect_ = self.btnRect {
                var x0 = Float(rect_.position.x)
                var y0 = Float(rect_.position.y)
                var x1 = Float(x0 + Float(self.size.width) - padding * 2)
                var y1 = Float(y0 + 60) //rect_
                
                if x0 < x && x < x1 {
                    if y0 < y && y < y1 {
                        start()
                        drawBlocks()
                        return
                    }
                }
            } */
            /*
            start()
            drawBlocks()
            return
*/
            drawBlocks()
        }
        
        if let size_ = self.blockSize {
            if x < padding || y < padding {
                return
            }
            x -= padding
            y -= padding
            
            var w0 = Float(size_.width)
            var h0 = Float(size_.height)
            
            var x0 = Float(floor(x / (w0 + padding)))
            var y0 = Float(floor(y / (h0 + padding)))
            
            if x - x0 * (w0 + padding) < w0 {
                if y - y0 * (h0 + padding) < h0 {
                    var x_ = Int(x0)
                    var y_ = Int(y0)
                    
                    var idx = y_ * 4 + x_
                    
                    if 0 <= idx && self.blocks.count > idx {
                        if nextNum == self.blocks[idx].num {
                            self.blocks[idx].checked = true
                            nextNum++
                            
                            if nextNum > self.blocks.count {
                                if let timer_ = timer {
                                    timer_.stop()
                                    is_playing = false
                                }
                            }
                        }
                    }
                    
                    println("\(x_),\(y_),\(idx)")
                    drawBlocks()
                }
            }
        }
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if let timer_ = timer {
            var s = timer_.getFormat()
            if is_playing == false {
                s += "\nCLEAR"
            }
            timerLabel!.text = s
        }
    }
}
