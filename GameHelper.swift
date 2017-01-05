//
//  GameState.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 1/6/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import Foundation

public enum GameState {
    case Playing
    case TapToPlay
    case GameOver
}

class GameHelper {
    static func random(maxValue: UInt32) -> UInt32 {
        return arc4random_uniform(maxValue + 1)
    }
}
