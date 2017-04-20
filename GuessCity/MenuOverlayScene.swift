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
    let game = GameHelper.sharedInstance

    var sceneView: SCNView!
    var gameScene: SCNScene!
    var blankScene: SCNScene!
    var gameOverlayScene: SKScene!
    var leaderboardOverlayScene: SKScene!
    var aboutOverlayScene: SKScene!

    override init(size: CGSize) {
        super.init(size: size)
    }

    func setup(sceneView: SCNView, gameScene: SCNScene, gameOverlayScene: SKScene, blankScene: SCNScene,
               leaderboardOverlayScene: SKScene,
               aboutOverlayScene: SKScene) {
        FontAwesomeIcon.register()

        self.sceneView = sceneView
        self.gameScene = gameScene
        self.gameOverlayScene = gameOverlayScene
        self.blankScene = blankScene
        self.leaderboardOverlayScene = leaderboardOverlayScene
        self.aboutOverlayScene = aboutOverlayScene

        let title = SKLabelNode(fontNamed: "tycho")
        title.fontSize = 20
        title.position.y = size.height - game.margin * 2
        title.position.x = size.width/2
        title.text = "CITYZEN"
        title.fontColor = GameHelper.sharedInstance.mainColor
        self.addChild(title)

        addButton(image: FontAwesomeIcon.playIcon.image(ofSize: game.largeIcon, color: game.mainColor), x: size.width/2, y: size.height/(13/10), name: "play")
        addButton(image: FontAwesomeIcon.trophyIcon.image(ofSize: game.mediumIcon, color: game.mainColor), x: size.width/(13/3), y: size.height/(13/3), name: "leaderboard")
        addButton(image: FontAwesomeIcon.thumbsUpAltIcon.image(ofSize: game.mediumIcon, color: game.mainColor), x: size.width/(13/6.5), y: size.height/(13/3), name: "rate")
        addButton(image: FontAwesomeIcon.infoSignIcon.image(ofSize: game.mediumIcon, color: game.mainColor), x: size.width/(13/10), y: size.height/(13/3), name: "about")
    }

    private func addButton(image: UIImage,  x: CGFloat,  y: CGFloat, name: String) {
        let texture = SKTexture(image: image)
        let button = SKSpriteNode(texture: texture)
        button.position.x = x
        button.position.y = y
        button.name = name

        self.addChild(button)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            if let node = nodes.first {
                game.playSound(filename: "misc_menu_4.wav")

                switch node.name! {
                case "play": play()
                case "leaderboard": showLeaderboard()
                case "rate": rate()
                case "about": showAbout()
                default: break
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func play() {
        game.fadeBackgroundMusic()

        self.sceneView.overlaySKScene = self.gameOverlayScene
        self.game.state = .Playing
        sceneView.present(gameScene, with: .fade(withDuration: 1), incomingPointOfView: nil, completionHandler: nil)
    }

    private func showLeaderboard() {
        self.sceneView.overlaySKScene = self.leaderboardOverlayScene
        sceneView.present(blankScene, with: .push(with: .right, duration: 1), incomingPointOfView: nil, completionHandler: nil)
    }

    private func showAbout() {
        self.sceneView.overlaySKScene = self.aboutOverlayScene
        sceneView.present(blankScene, with: .push(with: .left, duration: 1), incomingPointOfView: nil, completionHandler: nil)
    }

    private func rate() {
        let appID = "123"
        let urlStr = "itms-apps://itunes.apple.com/app/id\(appID)"
        let urlStr2 = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)"
        UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
    }
}
