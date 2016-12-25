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
    
    var overlayScene: OverlayScene!
    var earthScene: EarthScene!
    var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        earthScene = EarthScene()
        
        sceneView = self.view as! SCNView
        sceneView.allowsCameraControl = false
        sceneView.scene = earthScene
        
        overlayScene = OverlayScene(size: sceneView.bounds.size)
        overlayScene.addObserver(earthScene, forKeyPath: "paused", options: .new, context: nil)
        sceneView.overlaySKScene = overlayScene
        
        // cameraNode.runAction(SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0, z: -5, duration: 1)))
        // earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        sceneView.showsStatistics = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        sceneView.addGestureRecognizer(pinchGesture)
        pinchGesture.cancelsTouchesInView = false
    }
    
    func handlePinch(_ gestureRecognize: UIPinchGestureRecognizer) {
        
    }
    
    
    func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
        let location = gestureRecognize.location(in: sceneView)
        overlayScene.score += 1
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
