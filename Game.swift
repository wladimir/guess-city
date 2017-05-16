//
//  GameLogic.swift
//  Cityzen
//
//  Created by Vladimir Cirkovic on 5/16/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import Foundation

class Game {
    struct Answer {
        let turn: Int
        let lat: Double
        let lon: Double

        init(turn: Int, lat: Double, lon: Double) {
            self.turn = turn
            self.lat = lat
            self.lon = lon
        }
    }

    func computeScore(answer: Answer) -> Double {
        //let distance = planeDistance
        return 0.0
    }
}
