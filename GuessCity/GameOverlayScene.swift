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
    var city: SKLabelNode!
    var scores: SKLabelNode!
    // play button
    // back to menu button

    dynamic var center: Bool = false

    var score = 0 {
        didSet {
            self.city.text = "Score: \(self.score)"
            self.city.animate(newText: "May the source be with you", characterDelay: 0.1)
        }
    }

    override init(size: CGSize) {
        super.init(size: size)
        city = SKLabelNode(fontNamed: "Ampersand")
        city.fontSize = 10
        city.position.y = size.height/5
        city.position.x = size.width/5
        city.text = "EARTH!"

        self.addChild(city)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
