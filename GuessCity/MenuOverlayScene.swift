//
//  OverlayScene.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 12/25/16.
//  Copyright © 2016 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SpriteKit
import Iconic

class MenuOverlayScene: SKScene {
    // play button (largest)
    // leaderboard button (crown or axis)
    // settings button
    // title on top

    override init(size: CGSize) {
        super.init(size: size)

        FontAwesomeIcon.register()

        let title = SKLabelNode(fontNamed: "tycho")
        title.fontSize = 20
        title.position.y = size.height - 50
        title.position.x = size.width/2
        title.text = "Cityzen"
        self.addChild(title)

        let size = CGSize(width: 50, height: 50)
        let icon = FontAwesomeIcon.playIcon
        let image = icon.image(ofSize: size, color: .white)
        let texture = SKTexture(image: image)

        let text = SKSpriteNode(texture: texture)
        text.position.y = 50
        text.position.x = self.size.width/2
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
