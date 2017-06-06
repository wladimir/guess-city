//
//  GameViewController.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 11/25/16.
//  Copyright © 2016 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import CoreLocation
import AVFoundation
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    var gcEnabled = Bool()
    let gcDefaultLeaderBoard = "com.score.cityzen"

    var score = 0

    var sceneView: SCNView!
    var gameScene: GameScene!
    var menuScene: MenuScene!
    var gameOverlayScene: GameOverlayScene!
    var menuOverlayScene: MenuOverlayScene!

    let helper = Helper.sharedInstance

    var audioPlayer: AVAudioPlayer!

    let game = Game()

    var userLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let sceneView = self.view as? SCNView else {
            print("self.view is not SNCView \(self.view)")
            return
        }
        self.sceneView = sceneView

        authenticateLocalPlayer()

        gameScene = GameScene(named: "game.scn")
        menuScene = MenuScene(named: "menu.scn")
        sceneView.scene = menuScene

        gameOverlayScene = GameOverlayScene(size: sceneView.bounds.size)
        menuOverlayScene = MenuOverlayScene(size: sceneView.bounds.size)
        gameOverlayScene.setup(sceneView: sceneView, gameScene: gameScene, menuScene: menuScene,
                               menuOverlayScene: menuOverlayScene, game: game, gameViewController: self)
        menuOverlayScene.setup(sceneView: sceneView, gameScene: gameScene,
                               gameOverlayScene: gameOverlayScene, gameViewController: self)

        sceneView.overlaySKScene = menuOverlayScene

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sceneView.addGestureRecognizer(panGesture)

        helper.createMusicPlayer(filename: "BlueLineLoopFixed.mp3")
        helper.playBackgroundMusic()
    }

    @available(iOS 6.0, *)
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()

        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if viewController != nil {
                // show login if player is not logged in
                self.present(viewController!, animated: true, completion: {
                    self.getExistingScore()
                })
            } else if localPlayer.isAuthenticated {
                // player is already authenticated & logged in, load game center
                self.gcEnabled = true

                // get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (_, error) in
                    if error == nil {
                        self.getExistingScore()
                    }
                })
            } else {
                // game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
            }
        }
    }

    func getExistingScore() {
        let leaderboard = GKLeaderboard(players: [GKLocalPlayer.localPlayer()])
        leaderboard.identifier = gcDefaultLeaderBoard
        leaderboard.loadScores(completionHandler: { _, error in
            if error == nil {
                if let value = leaderboard.localPlayerScore {
                    self.gameOverlayScene.score = value.value
                }
            }
        })
    }

    func handlePan(_ gestureRecognize: UIPanGestureRecognizer) {
        if helper.state == .tapToPlay {
            return
        }

        let translation = gestureRecognize.translation(in: view!)
        let x = Float(translation.x)
        let y = Float(-translation.y)

        let anglePan = sqrt(pow(x, 2) + pow(y, 2))/2 * (Float).pi/180.0

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
        if helper.state == .tapToPlay {
            return
        }

        let eventLocation = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(eventLocation, options: [SCNHitTestOption.rootNode: self.gameScene.earthNode,SCNHitTestOption.ignoreChildNodes: true] )
        let hit = hitResults.first

        if hit == nil {
            return
        }

        let textureCoordinate = hit?.textureCoordinates(withMappingChannel: 0)
        userLocation = coordinateFromPoint(point: textureCoordinate!)

        setUserPin(vec: (hit?.localCoordinates)!)
    }

    func resetUserLocation() {
        userLocation = nil
    }

    func setUserPin(vec: SCNVector3) {
        gameScene.getUserPin().position = vec

        let pinDirection = GLKVector3Make(0.0, 1.0, 0.0)
        let normal = SCNVector3ToGLKVector3(vec)

        let rotationAxis = GLKVector3CrossProduct(pinDirection, normal)
        let cosAngle = GLKVector3DotProduct(pinDirection, normal)

        let rotation = GLKVector4MakeWithVector3(rotationAxis, acos(cosAngle))
        gameScene.getUserPin().rotation = SCNVector4FromGLKVector4(rotation)
    }

    func setActualPin(lat: Double, lon: Double) {
        let lat = lat * .pi/180
        let lon = lon * .pi/180
        let x = 1 * cos(lat) * sin(lon)
        let y = 1 * sin(lat)
        let z = 1 * cos(lat) * cos(lon)

        let vec = SCNVector3Make(Float(x), Float(y), Float(z))
        gameScene.getActualPin().position = vec

        let pinDirection2 = GLKVector3Make(0.0, 1.0, 0.0)
        let normal2 = SCNVector3ToGLKVector3(vec)

        let rotationAxis2 = GLKVector3CrossProduct(pinDirection2, normal2)
        let cosAngle2 = GLKVector3DotProduct(pinDirection2, normal2)

        let rotation2 = GLKVector4MakeWithVector3(rotationAxis2, acos(cosAngle2))
        gameScene.getActualPin().rotation = SCNVector4FromGLKVector4(rotation2)
    }

    func coordinateFromPoint(point: CGPoint) -> CLLocation {
        let u = Double(point.x)
        let v = Double(point.y)

        let lat: CLLocationDegrees = (0.5-v)*180.0
        let lon : CLLocationDegrees = (u-0.5)*360.0

        return CLLocation(latitude: lat, longitude: lon)
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
}
