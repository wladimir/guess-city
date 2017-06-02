//
//  Constants.swift
//  Cityzen
//
//  Created by Vladimir Cirkovic on 5/16/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import Foundation

struct Constants {
    static let  earthEquator                            = 6378137.0
    static let  distancePerDegree                       = (2 * .pi * earthEquator) / (360 * 1000)
    static let  scoreMaxDistance                        = 5000.0
    static let  maxResponseTime: CFTimeInterval         = 15.0
    static let  durationBetweenTurns: CFTimeInterval    = 5.0
}
