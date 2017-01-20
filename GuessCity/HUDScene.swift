//
//  OverlayScene.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 12/25/16.
//  Copyright © 2016 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SpriteKit

class HUDScene: SKScene {
    var labelNode:SKLabelNode!
    var scoreNode: SKLabelNode!

    dynamic var center: Bool = false

    var score = 0 {
        didSet {
            self.scoreNode.text = "Score: \(self.score)"
        }
    }

    override init(size: CGSize) {
        super.init(size: size)
        labelNode = SKLabelNode(fontNamed: "Menlo-Bold")
        labelNode.fontSize = 20
        labelNode.position.y = 50
        labelNode.position.x = 250
        labelNode.text = "EARTH!"

        self.addChild(labelNode)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
