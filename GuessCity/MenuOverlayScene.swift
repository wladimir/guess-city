//
//  OverlayScene.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 12/25/16.
//  Copyright © 2016 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SpriteKit

class MenuOverlayScene: SKScene {
    var labelNode:SKLabelNode!

    override init(size: CGSize) {
        super.init(size: size)
        labelNode = SKLabelNode(fontNamed: "tycho")
        labelNode.fontSize = 20
        labelNode.position.y = size.height/5
        labelNode.position.x = size.width/2
        labelNode.text = "super duper game"

        self.addChild(labelNode)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
