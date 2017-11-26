//
//  earthquakeClass.swift
//  Quakes
//
//  Created by Thijs van der Heijden on 11/25/17.
//  Copyright © 2017 Thijs van der Heijden. All rights reserved.
//

import Foundation

class EarthquakeModel {
    
    var lat: Double = 0.0
    var lon: Double = 0.0
    var strength: Double = 0.0
    var depth: Int = 0
    var title: String = ""
    var location: String = ""
    var image: String = ""
    
    init(lat: Double, lon: Double, strength: Double, depth: Int, title: String, location: String, image: String) {
        self.lat = lat
        self.lon = lon
        self.strength = strength
        self.depth = depth
        self.title = title
        self.location = location
        self.image = image
        
    }
}
