//
//  GameOverlayScene.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 2/10/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SpriteKit
import Iconic

class GameOverlayScene: SKScene {
    var city: SKLabelNode!
    var scores: SKLabelNode!
    
    dynamic var center: Bool = false

    var score = 0 {
        didSet {
            self.city.text = "Score: \(self.score)"
        }
    }

    override init(size: CGSize) {
        super.init(size: size)

        FontAwesomeIcon.register()

        city = SKLabelNode(fontNamed: "Ampersand")
        city.fontSize = 10
        city.position.y = size.height/5
        city.position.x = size.width/5
        city.text = "EARTH!"
        self.addChild(city)

        let largeSize = CGSize(width: 60, height: 60)
        let smallSize = CGSize(width: 30, height: 30)
        let secondRowX = (self.size.width - 50)/5
        let secondRowY = size.height/4

        addButton(image: FontAwesomeIcon.homeIcon.image(ofSize: smallSize, color: .white), x: self.size.width/2, y: (size.height/4)*3, name: "play")    }

    private func addButton(image: UIImage,  x: CGFloat,  y: CGFloat,  name: String) {
        let texture = SKTexture(image: image)
        let button = SKSpriteNode(texture: texture)
        button.position.y = y
        button.position.x = x
        button.name = name
        self.addChild(button)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
