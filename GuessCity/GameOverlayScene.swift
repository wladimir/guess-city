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
    let helper = Helper.sharedInstance

    var location1: SKLabelNode!
    var location2: SKLabelNode!
    var points: SKLabelNode!
    var band: SKShapeNode!

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

        let homeTexture = SKTexture(image: FontAwesomeIcon.arrowLeftIcon.image(ofSize: helper.smallIcon, color: helper.mainColor))
        let homeButton = SKSpriteNode(texture: homeTexture)
        homeButton.position.x = size.width - helper.margin
        homeButton.position.y = size.height - helper.margin
        homeButton.name = "menu"
        self.addChild(homeButton)

        location1 = addText(x: size.width/8, y: size.height/1.15, text: "BELGRADE", size: 20, name: "capital")
        location2 = addText(x: size.width/8, y: size.height/1.20, text: "SERBIA", size: 17, name: "country")

        let pointsText = "0 points"
        points = addText(x: size.width/7, y: size.height/6, text: pointsText, size: 20, name: "points")

        band = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
        band.fillColor = helper.bandColor
        band.strokeColor = helper.bandColor
        band.position.x = 0
        band.position.y = self.size.height
        self.addChild(band)
    }

    func runProgressBar() {
        let resize = SKAction.scaleX(to: self.frame.width, duration: 50)
        band.run(resize)
    }

    private func addText(x: CGFloat, y: CGFloat, text: String, size: CGFloat, name: String) -> SKLabelNode {
        let node = SKLabelNode(fontNamed: "Futura")
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
                if node.name == "menu" {
                    helper.playSound(filename: "misc_menu_4.wav")
                    backToMenu()
                }
            }
        }
    }

    private func backToMenu() {
        helper.fadeInBackgroundMusic()

        self.sceneView.overlaySKScene = self.menuOverlayScene
        self.helper.state = .tapToPlay
        sceneView.present(menuScene, with: .fade(withDuration: 2), incomingPointOfView: nil, completionHandler: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        // game loop
        // startTurn
        // wait 10 sec
        
        // end turn
        // wait?
    }
}
