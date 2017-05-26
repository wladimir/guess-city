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

class MenuOverlayScene: SKScene {
    let helper = Helper.sharedInstance

    var sceneView: SCNView!
    var gameScene: SCNScene!
    var gameOverlayScene: SKScene!

    weak var gameViewController: GameViewController!

    override init(size: CGSize) {
        super.init(size: size)
    }

    func setup(sceneView: SCNView, gameScene: SCNScene, gameOverlayScene: SKScene,
               gameViewController: GameViewController) {
        self.sceneView = sceneView
        self.gameScene = gameScene
        self.gameOverlayScene = gameOverlayScene

        self.gameViewController = gameViewController

        let title = SKLabelNode(fontNamed: "Futura")
        title.fontSize = 20
        title.position.y = size.height - 20
        title.position.x = size.width/2
        title.text = "CITYZEN"
        title.fontColor = helper.nonInteractiveColor
        self.addChild(title)

        let play = SKLabelNode(fontNamed: "Futura")
        play.fontSize = 50
        play.position.y = size.height/1.3
        play.position.x = size.width/2
        play.text = "PLAY"
        play.fontColor = helper.mainColor
        play.name = "play"
        self.addChild(play)

        let leaderboard = SKLabelNode(fontNamed: "Futura")
        leaderboard.fontSize = 30
        leaderboard.position.y = size.height/4.5
        leaderboard.position.x = size.width/2
        leaderboard.text = "LEADERBOARD"
        leaderboard.fontColor = helper.mainColor
        leaderboard.name = "leaderboard"
        self.addChild(leaderboard)

        let about = SKLabelNode(fontNamed: "Futura")
        about.fontSize = 20
        about.position.y = size.height/8
        about.position.x = size.width/2
        about.text = "ABOUT"
        about.fontColor = helper.mainColor
        about.name = "about"
        self.addChild(about)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            if let node = nodes.first {
                guard let name = node.name else {
                    return
                }

                helper.playSound(filename: "misc_menu_4.wav")
                
                switch name {
                case "play": play()
                case "leaderboard": showLeaderboard()
                case "about": showAboutScreen()
                default: break
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func play() {
        helper.fadeOutBackgroundMusic()

        self.sceneView.overlaySKScene = self.gameOverlayScene
        self.helper.state = .playing
        sceneView.present(gameScene, with: .fade(withDuration: 2), incomingPointOfView: nil, completionHandler: nil)
    }

    private func showLeaderboard() {

    }

    func showAboutScreen() {
        let aboutViewController = gameViewController.storyboard?.instantiateViewController(withIdentifier: "about")
        gameViewController.present(aboutViewController!, animated: true, completion: nil)
    }
}
