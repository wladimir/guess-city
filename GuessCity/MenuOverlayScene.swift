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
    override init(size: CGSize) {
        super.init(size: size)

        FontAwesomeIcon.register()

        let title = SKLabelNode(fontNamed: "tycho")
        title.fontSize = 20
        title.position.y = size.height - 50
        title.position.x = size.width/2
        title.text = "Cityzen"
        self.addChild(title)

        let text = SKLabelNode(fontNamed: "tycho")
        text.fontSize = 10
        text.position.y = (size.height/4)*3 + 40
        text.position.x = size.width/2
        text.text = "Tap to play"
        text.name = "tap"
        self.addChild(text)

        let largeSize = CGSize(width: 60, height: 60)
        let smallSize = CGSize(width: 30, height: 30)
        let secondRowX = (self.size.width - 50)/5
        let secondRowY = size.height/3
        let secondRowY1 = size.height/3.5
        let secondRowY2 = size.height/4

        addButton(image: FontAwesomeIcon.playIcon.image(ofSize: largeSize, color: .white), x: self.size.width/2, y: (size.height/4)*3, name: "play")
        addButton(image: FontAwesomeIcon.cogIcon.image(ofSize: smallSize, color: .white), x: secondRowX, y: secondRowY, name: "settings")
        addButton(image: FontAwesomeIcon.trophyIcon.image(ofSize: smallSize, color: .white), x: secondRowX*2, y: secondRowY1, name: "leaderboard")
        addButton(image: FontAwesomeIcon.infoSignIcon.image(ofSize: smallSize, color: .white), x: secondRowX*3, y: secondRowY2, name: "about")
        addButton(image: FontAwesomeIcon.thumbsUpAltIcon.image(ofSize: smallSize, color: .white), x: secondRowX*4, y: secondRowY1, name: "rate")
        addButton(image: FontAwesomeIcon.volumeOffIcon.image(ofSize: smallSize, color: .white), x: secondRowX*5, y: secondRowY, name: "volume")
    }

    private func addButton(image: UIImage,  x: CGFloat,  y: CGFloat,  name: String) {
        let texture = SKTexture(image: image)
        let button = SKSpriteNode(texture: texture)
        button.position.y = y
        button.position.x = x
        button.name = name
        self.addChild(button)
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
