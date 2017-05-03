//
//  Answer.swift
//  Cityzen
//
//  Created by Vladimir Cirkovic on 4/20/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import Foundation

struct Answer {
    let turn: Int
    let signature: String
    let lat: Double
    let lon: Double
}

extension Answer {
    init?(json: [String: Any]) {
        guard let turn = json["turn"] as? Int,
            let signature = json["signature"] as? String,
            let lat = json["lat"] as? Double,
            let lon = json["lon"] as? Double
                else {
                    return nil
            }

        self.turn = turn
        self.signature = signature
        self.lat = lat
        self.lon=lon
    }

    func toJSON() -> [String: Any] {
        let jsonObject: [String: Any] = [
            "turn": turn,
            "signature": signature,
            "lat": lat,
            "lon": lon
        ]
        return jsonObject
    }
}
