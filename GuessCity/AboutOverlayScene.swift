//
//  OverlayScene.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 12/25/16.
//  Copyright © 2016 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SpriteKit

class AboutOverlayScene: SKScene {
    var labelNode:SKLabelNode!

    override init(size: CGSize) {
        super.init(size: size)
        labelNode = SKLabelNode(fontNamed: "Menlo-Bold")
        labelNode.fontSize = 20
        labelNode.position.y = size.height/5
        labelNode.position.x = size.width/5
        labelNode.text = "about"

        self.addChild(labelNode)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
