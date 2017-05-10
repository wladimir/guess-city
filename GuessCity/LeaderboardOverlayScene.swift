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

class LeaderboardOverlayScene: SKScene {
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

        let title = SKLabelNode(fontNamed: "Futura-Medium")
        title.fontSize = 20
        title.position.y = 100
        title.position.x = 100
        title.text = "leaderboard"
        title.fontColor = game.mainColor
        self.addChild(title)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            if let node = nodes.first {
                if node.name == "home" {
                    game.playSound(filename: "misc_menu_4.wav")
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
        sceneView.present(menuScene, with: .push(with: .left, duration: 1), incomingPointOfView: nil, completionHandler: nil)
    }
}
