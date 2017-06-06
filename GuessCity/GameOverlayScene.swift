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
import GameKit

class GameOverlayScene: SKScene {
    private let helper = Helper.sharedInstance

    private var capital: SKLabelNode!
    private var country: SKLabelNode!
    private var points: SKLabelNode!
    private var band: SKShapeNode!
    private var message: SKLabelNode!

    private var timestamp: CFTimeInterval = 0.0
    private let maxResponseTime: CFTimeInterval = Constants.maxResponseTime
    private let durationBetweenTurns: CFTimeInterval = Constants.durationBetweenTurns

    private var game: Game!
    private var gameScene: GameScene!

    private let formatter = NumberFormatter()

    private weak var gameViewController: GameViewController!

    var score: Int64 = 0 {
        didSet {
            let formatted = formatter.string(from: NSNumber(value: score))
            self.points.text = "Score: \(formatted ?? "0")"
        }
    }

    private var sceneView: SCNView!
    private var menuScene: SCNScene!
    private var menuOverlayScene: SKScene!

    override init(size: CGSize) {
        super.init(size: size)

        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
    }

    func setup(sceneView: SCNView, gameScene: GameScene, menuScene: SCNScene, menuOverlayScene: SKScene, game: Game, gameViewController: GameViewController) {
        FontAwesomeIcon.register()

        self.sceneView = sceneView
        self.gameScene = gameScene
        self.menuScene = menuScene
        self.menuOverlayScene = menuOverlayScene
        self.game = game
        self.gameViewController = gameViewController

        let homeTexture = SKTexture(image: FontAwesomeIcon.arrowLeftIcon.image(ofSize: helper.smallIcon, color: helper.mainColor))
        let homeButton = SKSpriteNode(texture: homeTexture)
        homeButton.position.x = size.width - helper.margin
        homeButton.position.y = size.height - helper.margin
        homeButton.name = "menu"
        self.addChild(homeButton)

        capital = addText(x: size.width/8, y: size.height/1.15, text: "", size: 25, name: "capital")
        country = addText(x: size.width/8, y: size.height/1.21, text: "", size: 17, name: "country")

        let pointsText = "Score: 0"
        points = addText(x: size.width/7, y: size.height/5, text: pointsText, size: 20, name: "points")

        message = addText(x: size.width/2, y: size.height/9, text: "", size: 17, name: "message")
        message.horizontalAlignmentMode = .center

        band = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
        band.fillColor = helper.bandColor
        band.strokeColor = helper.bandColor
        band.position.x = 0
        band.position.y = self.size.height
        self.addChild(band)
    }

    func computeScore() {
        if let coord = gameViewController.userLocation?.coordinate {
            let (distance, score) = game.computeScore(lat: coord.latitude, lon: coord.longitude)
            updateMessage(distance: distance, score: score)
            updatePoints(score: score)
            submitToGC(score: score)
        }
    }

    func updateMessage(distance: Double, score: Int) {
        if score == 0 {
            message.text = "Too far away!"
            message.fontColor = UIColor.red
        } else if distance <= 1920 && distance > 1280 {
            message.text = "Not too bad!"
            message.fontColor = UIColor.orange
        } else if distance <= 1280 && distance > 640 {
            message.text = "Very good!"
            message.fontColor = UIColor.yellow
        } else if distance <= 640 {
            message.text = "Excellent!"
            message.fontColor = UIColor.green
        }
    }

    func updatePoints(score: Int) {
        let wait = SKAction.wait(forDuration: 0.001)
        let block = SKAction.run({
            self.score += 1
        })

        let sequence = SKAction.sequence([wait, block])
        points.run(SKAction.repeat(sequence, count: score))
    }

    func submitToGC(score: Int) {
        let bestScoreInt = GKScore(leaderboardIdentifier: "com.score.cityzen")
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }

    func runProgressBar() {
        let resize = SKAction.scaleX(to: self.frame.width/10, duration: 10)
        band.run(resize, completion: {
            self.endTurn()
            self.resetProgressBar()
            self.computeScore()

            let city = self.game.getCity()
            self.setActualPin(lat: city.lat, lon: city.lon)
        })
    }

    func setActualPin(lat: Double, lon: Double) {
        gameViewController.setActualPin(lat: lat, lon: lon)
    }

    func resetProgressBar() {
        band.removeAllActions()

        let resize = SKAction.scaleX(to: 0.1, duration: 0.1)
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

    override func didMove(to view: SKView) {
        startTurn()
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
        self.sceneView.overlaySKScene = self.menuOverlayScene
        self.helper.state = .tapToPlay
        resetProgressBar()
        sceneView.present(menuScene, with: .fade(withDuration: 2), incomingPointOfView: nil, completionHandler: {
            self.endTurn()
            self.gameScene.removePins()
            self.gameViewController.resetUserLocation()
            self.helper.fadeInBackgroundMusic()
        })
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func endTurn() {
        helper.state = .turnEnded
    }

    func startTurn() {
        helper.state = .turnStarted

        gameScene.removePins()
        gameViewController.resetUserLocation()

        game.startTurn()
        message.text = ""

        let city = game.getCity()
        capital.text = city.capital
        country.text = city.country

        runProgressBar()
    }

    override func update(_ currentTime: TimeInterval) {
        if helper.state == .tapToPlay {
            return
        }
        
        if currentTime - timestamp < maxResponseTime {
            return
        }
        
        if helper.state == .turnEnded {
            startTurn()
        }
        
        self.timestamp = currentTime
    }
}
