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
    var turn = 0

    init() {
        cities.load()
    }

    func startTurn() {
        self.turn += 1
    }

    func getCity() -> Cities.City {
        return cities.getCity(turn: turn)
    }

    func computeScore(lat: Double, lon: Double) -> (distance: Double, score: Int) {
        let city = cities.getCity(turn: turn)
        let distance  = planeDistance(lat1: city.lat, lon1: city.lon, lat2: lat, lon2: lon)
        return (distance, score(distance: distance))
    }

    private func planeDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let px = lon2 - lon1
        let py = lat2 - lat1

        return sqrt(px*px + py*py) * Constants.distancePerDegree
    }

    private func score(distance: Double) -> Int {
        let score = (Constants.scoreMaxDistance - distance)/10
        return Int(max(0, score))
    }
}
