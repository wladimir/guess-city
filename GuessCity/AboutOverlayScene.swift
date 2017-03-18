//
//  OverlayScene.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 12/25/16.
//  Copyright © 2016 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit
import Iconic

class AboutOverlayScene: SKScene {
    let game = GameHelper.sharedInstance

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

        let texture = SKTexture(image: FontAwesomeIcon.homeIcon.image(ofSize: CGSize(width: 30, height: 30), color: .white))
        let button = SKSpriteNode(texture: texture)
        button.position.x = 50
        button.position.y = 50
        button.name = "home"
        self.addChild(button)

        let title = SKLabelNode(fontNamed: "tycho")
        title.fontSize = 20
        title.position.y = 100
        title.position.x = 100
        title.text = "about"
        title.fontColor = .white
        self.addChild(title)
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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func backToMenu() {
        self.sceneView.overlaySKScene = self.menuOverlayScene
        sceneView.present(menuScene, with: .push(with: .right, duration: 1), incomingPointOfView: nil, completionHandler: nil)
    }
}
