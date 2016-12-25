//
//  EarthScene.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 12/25/16.
//  Copyright © 2016 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SceneKit

class EarthScene: SCNScene {
    var earthNode: SCNNode!
    var cameraNode: SCNNode!
    
    override init() {
        super.init()
        
        let earth = SCNSphere(radius: 3.0)
        let material = SCNMaterial()
        
        material.diffuse.contents = UIImage(named: "earthmap4k.jpg")
        material.specular.contents = UIImage(named: "earthspec4k.jpg")
        material.normal.contents = UIImage(named: "earthnormal4k.jpg")
        material.multiply.contents = UIColor(white: 0.7, alpha: 1.0)
        material.shininess = 1;
        
        earth.firstMaterial = material
        
        let earthNode = SCNNode(geometry: earth)
        rootNode.addChildNode(earthNode)
        self.earthNode = earthNode;
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        
        let constraint = SCNLookAtConstraint(target: earthNode)
        constraint.isGimbalLockEnabled = true
        
        rootNode.addChildNode(cameraNode)
        self.cameraNode = cameraNode
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        rootNode.addChildNode(ambientLightNode)
        
        background.contents = UIImage(named: "galaxy_starfield.png")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "paused" {
            if let c = change as? [NSKeyValueChangeKey: Bool] {
                if let paused = c[.newKey] {
                   print("paused")
                }
            }
        }
    }
}
