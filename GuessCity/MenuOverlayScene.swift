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
    // play button (largest)
    // leaderboard button (crown or axis)
    // settings button
    // title on top

    override init(size: CGSize) {
        super.init(size: size)

        let title = SKLabelNode(fontNamed: "tycho")
        title.fontSize = 20
        title.position.y = size.height - 50
        title.position.x = size.width/2
        title.text = "Cityzen"
        self.addChild(title)

        let text = SKLabelNode(fontNamed: "FontAwesome")
        text.text = "tap to play"
        text.fontSize = 15
        text.position.y = 50
        text.position.x = size.width/2
        text.fontColor = UIColor.green
        text.name = "tap"
        self.addChild(text)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            if let node = nodes.first {
                if node.name == "tap" {
                    print("playyyy")
                }
            }
        }
        super.touchesBegan(touches, with: event)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
