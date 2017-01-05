//
//  OverlayScene.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 12/25/16.
//  Copyright © 2016 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SpriteKit

class OverlayScene: SKScene {
    var menuNode: SKSpriteNode!
    var scoreNode: SKLabelNode!
    
    dynamic var center: Bool = false
    
    var score = 0 {
        didSet {
            self.scoreNode.text = "Score: \(self.score)"
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = UIColor.clear
        let spriteSize = size.width / 12
        menuNode = SKSpriteNode(imageNamed: "Pause Button")
        menuNode.size = CGSize(width: spriteSize, height: spriteSize)
        menuNode.position = CGPoint(x: spriteSize + 20, y: spriteSize + 20)
        
        scoreNode = SKLabelNode(text: "Score: 0")
        scoreNode.fontName = "DINAlternate-Bold"
        scoreNode.fontColor = UIColor.white
        scoreNode.fontSize = 24
        scoreNode.position = CGPoint(x: size.width/2, y: self.menuNode.position.y - 9)
        
        addChild(self.menuNode)
        addChild(self.scoreNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        if self.menuNode.contains(location) {
            print("contains")
            self.center = !self.center
        }
    }
}
