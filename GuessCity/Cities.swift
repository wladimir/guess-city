//
//  Cities.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 1/5/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import Foundation

class Cities {
    var cities = [City]()

    class City {
        let city: String
        let country: String
        let lat: Double
        let lon: Double

        init(city: String, country: String, lat: Double, lon: Double) {
            self.city = city
            self.country = country
            self.lat = lat
            self.lon = lon
        }
    }
}
