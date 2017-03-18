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
import CoreLocation
import AVFoundation

class GameViewController: UIViewController {
    var sceneView: SCNView!
    var gameScene: GameScene!
    var menuScene: MenuScene!
    var blankScene: BlankScene!
    var gameOverlayScene: GameOverlayScene!
    var menuOverlayScene: MenuOverlayScene!
    var leaderboardOverlayScene: LeaderboardOverlayScene!
    var aboutOverlayScene: AboutOverlayScene!

    let game = GameHelper.sharedInstance

    let cities = Cities()

    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView = self.view as! SCNView

        gameScene = GameScene(named: "game.scn")
        menuScene = MenuScene(named: "menu.scn")
        blankScene = BlankScene(named: "blank.scn")
        sceneView.scene = menuScene

        gameOverlayScene = GameOverlayScene(size: sceneView.bounds.size)
        menuOverlayScene = MenuOverlayScene(size: sceneView.bounds.size)
        leaderboardOverlayScene = LeaderboardOverlayScene(size: sceneView.bounds.size)
        aboutOverlayScene = AboutOverlayScene(size: sceneView.bounds.size)

        gameOverlayScene.setup(sceneView: sceneView, menuScene: menuScene, menuOverlayScene: menuOverlayScene)
        menuOverlayScene.setup(sceneView: sceneView, gameScene: gameScene, gameOverlayScene: gameOverlayScene, blankScene: blankScene, leaderboardOverlayScene: leaderboardOverlayScene, aboutOverlayScene: aboutOverlayScene)
        leaderboardOverlayScene.setup(sceneView: sceneView, menuScene: menuScene, menuOverlayScene: menuOverlayScene)
        aboutOverlayScene.setup(sceneView: sceneView, menuScene: menuScene, menuOverlayScene: menuOverlayScene)

        sceneView.overlaySKScene = menuOverlayScene

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sceneView.addGestureRecognizer(panGesture)

        cities.load()
        print(cities.cities[2].lon)

        setupSounds()
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
        if game.state != .Playing {
            return
        }

        // gameScene.turnStarted()

        let eventLocation = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(eventLocation, options: [SCNHitTestOption.rootNode:self.gameScene.earthNode,SCNHitTestOption.ignoreChildNodes:true] )
        let hit = hitResults.first

        if (hit == nil) {
            return
        }

        let textureCoordinate = hit?.textureCoordinates(withMappingChannel: 0)
        let location: CLLocation = coordinateFromPoint(point: textureCoordinate!)

        print(location)
    }

    private func coordinateFromPoint(point:CGPoint) -> CLLocation
    {
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

    private func setupSounds() {
        // if game.state == .TapToPlay {}

        playBackgroundMusic(filename: "BlueLineLoopFixed.mp3")

        game.loadSound(name: "positive", fileNamed: "Rise03.wav")
        game.loadSound(name: "negative", fileNamed: "Downer01.wav")
        game.loadSound(name: "click", fileNamed: "misc_menu_4.wav")
    }

    func playBackgroundMusic(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: newURL)
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = 0.4
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
}
