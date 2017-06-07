//
//  Cities.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 1/5/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import SQLite

class Cities {
    private var cities = [City]()

    struct City {
        let capital: String
        let country: String
        let lat: Double
        let lon: Double

        init(capital: String, country: String, lat: Double, lon: Double) {
            self.capital = capital
            self.country = country
            self.lat = lat
            self.lon = lon
        }
    }

    func load() {
        do {
            let path = Bundle.main.path(forResource:"cities", ofType: "db")!
            let db = try Connection(path, readonly: true)

            let statement = try db.run("SELECT name, country, latitude, longitude FROM cities ORDER BY RANDOM()", [:])
            //let statement = try db.run("SELECT name, country, latitude, longitude FROM cities where name in ('New York City', 'Rio de Janeiro')", [:])

            for row in statement where row.count == 4 {
                guard let capital = row[0] as? String else {
                    print("Error with \(row)")
                    return
                }
                guard let country = row[1] as? String else {
                    print("Error with \(row)")
                    return
                }
                guard let lat = row[2] as? Double else {
                    print("Error with \(row)")
                    return
                }
                guard let lon = row[3] as? Double else {
                    print("Error with \(row)")
                    return
                }
                let city = City(capital: capital, country: country, lat: lat, lon: lon)
                self.cities.append(city)
            }
        } catch {
            print ("Datatabase error: \(error)")
        }
    }

    func getCity(turn: Int) -> City {
        return cities[turn%cities.count]
    }
}
