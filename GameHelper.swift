//
//  GameState.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 1/6/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

public enum GameState {
    case Playing
    case TapToPlay
    case GameOver
}

class GameHelper {
    var state = GameState.TapToPlay

    static let sharedInstance = GameHelper()

    var sounds = [String:SCNAudioSource]()

    static func random(maxValue: UInt32) -> UInt32 {
        return arc4random_uniform(maxValue + 1)
    }

    func loadSound(name:String, fileNamed:String) {
        if let sound = SCNAudioSource(fileNamed: fileNamed) {
            sound.isPositional = false
            sound.volume = 0.3
            sound.load()
            sounds[name] = sound
        }
    }

    func playSound(node:SCNNode, name:String) {
        let sound = sounds[name]
        node.runAction(SCNAction.playAudio(sound!, waitForCompletion: false))
    }
}
