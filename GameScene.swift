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

    private var pin: SCNNode!

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

    func getPin() -> SCNNode {
        if (pin == nil) {
            let bodyHeight: CGFloat = 0.3;
            let bodyRadius: CGFloat = 0.015;
            let headRadius: CGFloat = 0.06;

            let body = SCNCylinder(radius: bodyRadius, height: bodyHeight)
            let head = SCNSphere(radius: headRadius)

            let headMaterial = SCNMaterial()
            let bodyMaterial = SCNMaterial()

            headMaterial.diffuse.contents = UIColor.red
            headMaterial.emission.contents = UIColor(red: 0.2, green: 0, blue: 0, alpha: 1.0)
            bodyMaterial.specular.contents = UIColor.white
            bodyMaterial.emission.contents = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
            headMaterial.specular.contents = UIColor.white
            bodyMaterial.shininess = 100;

            head.firstMaterial = headMaterial;
            body.firstMaterial = bodyMaterial;

            let bodyNode = SCNNode(geometry: body)
            bodyNode.position = SCNVector3Make(0, Float(bodyHeight/2.0), 0)
            let headNode = SCNNode(geometry: head)
            headNode.position = SCNVector3Make(0, Float(bodyHeight), 0)

            let pinNode = SCNNode()
            pinNode.addChildNode(bodyNode)
            pinNode.addChildNode(headNode)

            earthNode.addChildNode(pinNode)
            self.pin = pinNode
        }
        return pin
    }
}
