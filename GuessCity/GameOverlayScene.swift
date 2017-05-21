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
    let gameHelper = GameHelper.sharedInstance

    var location1: SKLabelNode!
    var location2: SKLabelNode!
    var points: SKLabelNode!
    var pos: SKLabelNode!
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

        let homeTexture = SKTexture(image: FontAwesomeIcon.arrowLeftIcon.image(ofSize: gameHelper.smallIcon, color: gameHelper.mainColor))
        let homeButton = SKSpriteNode(texture: homeTexture)
        homeButton.position.x = size.width - gameHelper.margin
        homeButton.position.y = size.height - gameHelper.margin
        homeButton.name = "home"
        self.addChild(homeButton)

        location1 = addText(x: size.width/10, y: size.height/(13/11), text: "Waiting for next turn!", size: 17)
        location2 = addText(x: size.width/10, y: size.height/(13/10.5), text: "Asd", size: 17)

        let pointsText = "0"
        addButton(image: FontAwesomeIcon.starIcon.image(ofSize: gameHelper.smallIcon, color: gameHelper.pointsColor),
                  x: gameHelper.margin, y: gameHelper.margin, name: "star")
        points = addText(x: gameHelper.margin * 2, y: gameHelper.margin, text: pointsText, size: 17)

        addButton(image: FontAwesomeIcon.globeIcon.image(ofSize: gameHelper.smallIcon, color: gameHelper.positionColor),
                  x: size.width - gameHelper.margin, y: gameHelper.margin, name: "globe")
        let posText = "0/0"
        pos = addText(x: size.width - 3 * gameHelper.margin - CGFloat(posText.characters.count), y: gameHelper.margin, text: posText , size: 17)

        band = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
        band.fillColor = gameHelper.bandColor
        band.strokeColor = gameHelper.bandColor
        band.position.x = 0
        band.position.y = self.size.height
        self.addChild(band)
    }

    func runProgressBar() {
        let resize = SKAction.scaleX(to: self.frame.width, duration: 50)
        band.run(resize)
    }

    private func addButton(image: UIImage, x: CGFloat, y: CGFloat, name: String) {
        let texture = SKTexture(image: image)
        let button = SKSpriteNode(texture: texture)
        button.position.x = x
        button.position.y = y
        button.name = name

        self.addChild(button)
    }

    private func addText(x: CGFloat, y: CGFloat, text: String, size: CGFloat) -> SKLabelNode {
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
                if node.name == "home" {
                    gameHelper.soundsPlayer.play()
                    //backToMenu()
                    runProgressBar()
                }
            }
        }
    }

    private func backToMenu() {
        gameHelper.fadeInBackgroundMusic()

        self.sceneView.overlaySKScene = self.menuOverlayScene
        sceneView.present(menuScene, with: .fade(withDuration: 1), incomingPointOfView: nil, completionHandler: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */

        // game loop
        print(currentTime)
    }
}
