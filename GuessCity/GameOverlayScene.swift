//
//  GameOverlayScene.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 2/10/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit
import Iconic

class GameOverlayScene: SKScene {
    let bandColor: UIColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(87/255.0), blue: CGFloat(51/255.0), alpha: CGFloat(1.0))
    let color: UIColor = UIColor.white

    var location: SKLabelNode!
    var points: SKLabelNode!
    var pos: SKLabelNode!
    var band: SKNode!

    var score = 0 {
        didSet {
            self.points.text = "Score: \(self.score)"
        }
    }

    var sceneView: SCNView!
    var menuScene: SCNScene!
    var menuOverlayScene: SKScene!

    // home icon is button
    // star -> points, players -> position

    override init(size: CGSize) {
        super.init(size: size)
    }

    func setup(sceneView: SCNView, menuScene: SCNScene, menuOverlayScene: SKScene) {
        FontAwesomeIcon.register()

        self.sceneView = sceneView
        self.menuScene = menuScene
        self.menuOverlayScene = menuOverlayScene

        location = addText(x: size.width/10, y: size.height/(13/12), text: "Waiting for next turn!", size: 17)
        points = addText(x: size.width/10, y: size.height/(26/4), text: "100", size: 17)
        pos = addText(x: size.width/10, y: size.height/(26/3), text: "2 / 5" , size: 17)

        band = SKSpriteNode(color: bandColor, size: CGSize(width: 20, height: 20))
        band.position.x = 0
        band.position.y = self.size.height
        self.addChild(band)
    }

    private func addText(x: CGFloat,  y: CGFloat, text: String, size: CGFloat) -> SKLabelNode {
        let node = SKLabelNode(fontNamed: "Futura-Medium")
        node.fontSize = size
        node.position.x = x
        node.position.y = y
        node.name = name
        node.text = text
        node.horizontalAlignmentMode = .left

        self.addChild(node)
        
        return node
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
