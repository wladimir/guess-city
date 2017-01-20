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
    var earthScene: EarthScene!
    var sceneView: SCNView!

    let cities = Cities()

    override func viewDidLoad() {
        super.viewDidLoad()

        earthScene = EarthScene()
        sceneView = self.view as! SCNView
        sceneView.scene = earthScene

        // cameraNode.runAction(SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0, z: -5, duration: 1)))
        // earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))

        sceneView.showsStatistics = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        sceneView.addGestureRecognizer(pinchGesture)
        pinchGesture.cancelsTouchesInView = false

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sceneView.addGestureRecognizer(panGesture)
        panGesture.cancelsTouchesInView = false

        cities.load()
        print(cities.cities[2].lon)

        // hudScene.scoreNode.run(SKAction.fadeOut(withDuration: 2.0))
    }

    func showMenu() {

    }

    func handlePinch(_ gestureRecognize: UIPinchGestureRecognizer) {

    }

    func handlePan(_ gestureRecognize: UIPanGestureRecognizer) {
        let translation = gestureRecognize.translation(in: view!)
        let x = Float(translation.x)
        let y = Float(-translation.y)

        let anglePan = sqrt(pow(x, 2) + pow(y, 2))/2 * (Float)(M_PI)/180.0

        let rotationVector = SCNVector4(-y, x, 0, anglePan)
        earthScene.earthNode.rotation = rotationVector

        if gestureRecognize.state == .ended {
            let currentPivot = earthScene.earthNode.pivot
            let changePivot = SCNMatrix4Invert(earthScene.earthNode.transform)

            earthScene.earthNode.pivot = SCNMatrix4Mult(changePivot, currentPivot)
            earthScene.earthNode.transform = SCNMatrix4Identity
        }
    }

    func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
        let location = gestureRecognize.location(in: sceneView)
        //hudScene.score += 1
        sceneView.isPlaying = true

        let hitResults = sceneView.hitTest(location, with: nil)
        // print(">", hitResults!)

        print (location)
        if self.earthScene.hudScene.contains(location) {
            print("contains")
        }
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
