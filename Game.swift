//
//  GameLogic.swift
//  Cityzen
//
//  Created by Vladimir Cirkovic on 5/16/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import Foundation

class Game {
    let cities = Cities()

    init() {
        cities.load()
    }

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

    func computeScore(answer: Answer) -> Int {
        let city = cities.getCity(turn: answer.turn)
        let distance  = planeDistance(lat1: city.lat, lon1: city.lon, lat2: answer.lat, lon2: answer.lon)
        return score(distance: distance)
    }

    func planeDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let px = lon2 - lon1
        let py = lat2 - lat1

        return sqrt(px*px + py*py) * Constants.distancePerDegree
    }

    func score(distance: Double) -> Int {
        let score = Constants.scoreMaxDistance - distance
        return Int(max(0, score))
    }
}
