//
//  GameViewController.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 11/25/16.
//  Copyright © 2016 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {
    var sceneView: SCNView!
    var gameScene: GameScene!
    var gameOverlayScene: GameOverlayScene!
    var menuScene: MenuScene!
    var menuOverlayScene: MenuOverlayScene!

    let game = GameHelper.sharedInstance

    let cities = Cities()

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView = self.view as! SCNView

        gameScene = GameScene(named: "earth.scn")
        menuScene = MenuScene(named: "menu.scn")
        sceneView.scene = menuScene

        gameOverlayScene = GameOverlayScene(size: sceneView.bounds.size)
        menuOverlayScene = MenuOverlayScene(size: sceneView.bounds.size)
        sceneView.overlaySKScene = menuOverlayScene

        // cameraNode.runAction(SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0, z: -5, duration: 1)))
        // earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
//        tapGesture.cancelsTouchesInView = false

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sceneView.addGestureRecognizer(panGesture)
//        panGesture.cancelsTouchesInView = false

        cities.load()
        print(cities.cities[2].lon)

        setupSounds()

        let turnStarted = SCNAction.run { (node) in
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1

            self.gameScene.earthNode.pivot = self.gameScene.pivot
            self.gameScene.earthNode.rotation = self.gameScene.rotation
            self.gameScene.earthNode.transform = SCNMatrix4Identity

            SCNTransaction.commit()
        }
    }

    func handlePan(_ gestureRecognize: UIPanGestureRecognizer) {
        if game.state != .Playing {
            return
        }

        let translation = gestureRecognize.translation(in: view!)
        let x = Float(translation.x)
        let y = Float(-translation.y)

        let anglePan = sqrt(pow(x, 2) + pow(y, 2))/2 * (Float)(M_PI)/180.0

        let rotationVector = SCNVector4(-y, x, 0, anglePan)

        gameScene.earthNode.rotation = rotationVector

        if gestureRecognize.state == .ended {
            let currentPivot = gameScene.earthNode.pivot
            let changePivot = SCNMatrix4Invert(gameScene.earthNode.transform)

            gameScene.earthNode.pivot = SCNMatrix4Mult(changePivot, currentPivot)
            gameScene.earthNode.transform = SCNMatrix4Identity
        }
    }

    func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
        if game.state == .TapToPlay {
            showGame()
            return
        }

        let location = gestureRecognize.location(in: sceneView)
        //hudScene.score += 1
        sceneView.isPlaying = true

        let hitResults = sceneView.hitTest(location, with: nil)
        // print(">", hitResults!)

        //if self.earthScene.hudScene.contains(location) {
        //  print("contains")
        //}
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "center" {
            if let c = change as? [NSKeyValueChangeKey: Bool] {
                if c[.newKey] != nil {
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 1

                    gameScene.earthNode.pivot = gameScene.pivot
                    gameScene.earthNode.rotation = gameScene.rotation
                    gameScene.earthNode.transform = SCNMatrix4Identity

                    SCNTransaction.commit()
                }
            }
        }
    }

    func setupSounds() {
        if game.state == .TapToPlay {
            let music = SCNAudioSource(fileNamed: "BlueLineLoopFixed.mp3")
            music!.volume = 0.3;
            music!.loops = true
            music!.shouldStream = false
            music!.isPositional = false
            let musicPlayer = SCNAudioPlayer(source: music!)
            music!.volume = 0.5;
            menuScene.rootNode.addAudioPlayer(musicPlayer)
        } else {
            game.loadSound(name: "positive", fileNamed: "Rise03.wav")
            game.loadSound(name: "negative", fileNamed: "Downer01.wav")
        }
    }
    
    func showMenu() {
        gameScene.isPaused = true
        let transition = SKTransition.fade(with: .black, duration: 2.0)
        sceneView.present(menuScene, with: transition, incomingPointOfView: nil, completionHandler: {
            self.game.state = .TapToPlay
            self.setupSounds()
            self.menuScene.isPaused = false
            self.sceneView.overlaySKScene = self.menuOverlayScene
        })
    }
    
    func showGame() {
        menuScene.isPaused = true
        let transition = SKTransition.fade(with: .black, duration: 2.0)
        sceneView.present(gameScene, with: transition, incomingPointOfView: nil, completionHandler: {
            self.game.state = .Playing
            self.setupSounds()
            self.gameScene.isPaused = false
            self.sceneView.overlaySKScene = self.gameOverlayScene
        })
    }
}
