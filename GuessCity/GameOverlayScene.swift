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
    let game = GameHelper.sharedInstance

    var location1: SKLabelNode!
    var location2: SKLabelNode!
    var points: SKLabelNode!
    var pos: SKLabelNode!
    var band: SKNode!
    let fire = "🔥"

    var score = 0 {
        didSet {
            self.points.text = "Score: \(self.score)"
        }
    }

    var sceneView: SCNView!
    var menuScene: SCNScene!
    var menuOverlayScene: SKScene!

    override init(size: CGSize) {
        super.init(size: size)
    }

    func setup(sceneView: SCNView, menuScene: SCNScene, menuOverlayScene: SKScene) {
        FontAwesomeIcon.register()

        self.sceneView = sceneView
        self.menuScene = menuScene
        self.menuOverlayScene = menuOverlayScene

        let homeTexture = SKTexture(image: FontAwesomeIcon.homeIcon.image(ofSize: CGSize(width: 20, height: 20), color: game.mainColor))
        let homeButton = SKSpriteNode(texture: homeTexture)
        homeButton.position.x = size.width - 15
        homeButton.position.y = size.height - 25
        homeButton.name = "home"
        self.addChild(homeButton)

        location1 = addText(x: size.width/10, y: size.height/(13/12), text: "Waiting for next turn!", size: 17)
        location2 = addText(x: size.width/10, y: size.height/(13/10), text: "", size: 17)
        points = addText(x: (size.width/10)*3, y: size.height/(26/4), text: "⭐ 1000000 points", size: 17)
        pos = addText(x: (size.width/10)*7, y: size.height/(26/4), text: "👥 2/5 players" , size: 17)

        band = SKSpriteNode(color: GameHelper.sharedInstance.bandColor, size: CGSize(width: 20, height: 20))
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
        node.verticalAlignmentMode = .center

        self.addChild(node)

        return node
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            if let node = nodes.first {
                if (node.name == "home") {
                    game.soundsPlayer.play()
                    backToMenu()
                }
            }
        }
    }

    private func backToMenu() {
        self.sceneView.overlaySKScene = self.menuOverlayScene
        sceneView.present(menuScene, with: .fade(withDuration: 1), incomingPointOfView: nil, completionHandler: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
