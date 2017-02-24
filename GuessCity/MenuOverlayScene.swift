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
    var title: SKLabelNode!
    var text: SKLabelNode!
    // play button (largest)
    // leaderboard button (crown or axis)
    // settings button

    override init(size: CGSize) {
        super.init(size: size)
        title = SKLabelNode(fontNamed: "tycho")
        title.fontSize = 20
        title.position.y = size.height/5
        title.position.x = size.width/2
        title.text = "Cityzen"

        self.addChild(title)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
