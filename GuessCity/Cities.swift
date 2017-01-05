//
//  Cities.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 1/5/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import Foundation

class Cities {
    var cities = Array<City>()
    
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
    
    func load() {
        let path = Bundle.main.path(forResource: "cities", ofType: "plist")
        let cities = NSArray(contentsOfFile: path!)
        
        for el in cities! {
            let dict = el as! Dictionary<String, Any>
            let city = City(city: dict["Capital"] as! String, country: dict["Country"] as! String, lat: dict["Latitude"] as! Double, lon: dict["Longitude"] as! Double)
            self.cities.append(city)
        }
    }
}
