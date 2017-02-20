//
//  GameScene.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 1/21/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import UIKit
import SceneKit

class MenuScene: SCNScene {
    var earthNode: SCNNode!

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        earthNode = self.rootNode.childNode(withName: "earthm", recursively: true)!

        addRotateAnimation()
    }

    func addRotateAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "rotation.w")
        rotateAnimation.byValue = M_PI*2.0
        rotateAnimation.duration = 50
        rotateAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        rotateAnimation.repeatCount = .infinity;

        earthNode.addAnimation(rotateAnimation, forKey: "rotate the earth")
    }

    func pauseRotateAnimation() {
        earthNode.pauseAnimation(forKey: "rotate the earth")
    }
}
