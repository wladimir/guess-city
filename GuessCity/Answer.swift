//
//  Answer.swift
//  Cityzen
//
//  Created by Vladimir Cirkovic on 4/20/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import Foundation

class Answer {
    let turn: Int
    let lat: Double
    let lon: Double

    init(turn: Int, lat: Double, lon: Double) {
        self.turn = turn
        self.lat = lat
        self.lon = lon
    }
}
