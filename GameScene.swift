//
//  GameScene.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 1/21/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SceneKit

class GameScene: SCNScene {
    var earthNode: SCNNode!
    var cameraNode: SCNNode!

    var pivot: SCNMatrix4!
    var rotation: SCNVector4!

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        earthNode = self.rootNode.childNode(withName: "earth", recursively: true)!
        cameraNode = self.rootNode.childNode(withName: "camera", recursively: true)!

        earthNode = self.rootNode.childNode(withName: "earth", recursively: true)!
        earthNode.rotation = SCNVector4Make(0, 1, 0, 0)

        pivot = earthNode.pivot
        rotation = earthNode.rotation
    }

    func turnStarted() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        earthNode.pivot = pivot
        earthNode.rotation = rotation
        earthNode.transform = SCNMatrix4Identity
        SCNTransaction.commit()
    }
}
