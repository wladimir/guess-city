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

class GameViewController: UIViewController {
    var sceneView: SCNView!
    var gameScene: GameScene!
    var menuScene: MenuScene!
    var aboutScene: AboutScene!
    var gameOverlayScene: GameOverlayScene!
    var menuOverlayScene: MenuOverlayScene!
    var aboutOverlayScene: AboutOverlayScene!

    let game = GameHelper.sharedInstance

    let cities = Cities()

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView = self.view as! SCNView

        gameScene = GameScene(named: "game.scn")
        menuScene = MenuScene(named: "menu.scn")
        aboutScene = AboutScene(named: "about.scn")
        sceneView.scene = menuScene
        sceneView.isPlaying = true

        gameOverlayScene = GameOverlayScene(size: sceneView.bounds.size)
        menuOverlayScene = MenuOverlayScene(size: sceneView.bounds.size)
        aboutOverlayScene = AboutOverlayScene(size: sceneView.bounds.size)
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

        let eventLocation = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(eventLocation, options: [SCNHitTestOption.rootNode:self.gameScene.earthNode,SCNHitTestOption.ignoreChildNodes:true] )
        let hit = hitResults.first

        if (hit == nil) {
            return
        }

        let translation = gestureRecognize.translation(in: view!)
        let x = Float(translation.x)
        let y = Float(-translation.y)

        // if doesn't hit with earth, return

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
            sceneView.present(gameScene, with: .fade(withDuration: 1.5), incomingPointOfView: nil, completionHandler: {
                self.sceneView.overlaySKScene = self.gameOverlayScene;
                self.game.state = .Playing
                self.gameOverlayScene.score += 1
            })
            sceneView.isPlaying = true
            gameOverlayScene.isPaused = false
            gameScene.isPaused = false
            menuScene.isPaused = false
            return
        }

        //gameScene.turnStarted()

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
        let u = Double(point.x);
        let v = Double(point.y);

        let lat: CLLocationDegrees = (0.5-v)*180.0;
        let lon : CLLocationDegrees = (u-0.5)*360.0;

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
        if game.state == .TapToPlay {
            let music = SCNAudioSource(fileNamed: "BlueLineLoopFixed.mp3")
            music!.volume = 0.3;
            music!.loops = true
            music!.shouldStream = false
            music!.isPositional = false
            let musicPlayer = SCNAudioPlayer(source: music!)
            music!.volume = 0.4;
            menuScene.rootNode.addAudioPlayer(musicPlayer)
        } else {
            game.loadSound(name: "positive", fileNamed: "Rise03.wav")
            game.loadSound(name: "negative", fileNamed: "Downer01.wav")
            
        }
    }
}
