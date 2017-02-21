//
//  GameOverlayScene.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 2/10/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverlayScene: SKScene {
    var labelNode:SKLabelNode!

    dynamic var center: Bool = false

    var score = 0 {
        didSet {
            self.labelNode.text = "Score: \(self.score)"
            self.labelNode.animate(newText: "May the source be with you", characterDelay: 0.1)
        }
    }

    override init(size: CGSize) {
        super.init(size: size)
        labelNode = SKLabelNode(fontNamed: "Menlo-Bold")
        labelNode.fontSize = 20
        labelNode.position.y = size.height/5
        labelNode.position.x = size.width/5
        labelNode.text = "EARTH!"

        self.addChild(labelNode)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
