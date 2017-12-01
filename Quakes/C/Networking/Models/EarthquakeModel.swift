//
//  earthquakeClass.swift
//  Quakes
//
//  Created by Thijs van der Heijden on 11/25/17.
//  Copyright © 2017 Thijs van der Heijden. All rights reserved.
//

import Foundation
import SwiftyJSON

final class EarthquakeModel {
    
    var lon: Double
    var lat: Double
    var title: String
    var depth: Int
    var strength: Double
    var location: String
    var dateTime: String
    
    init(json: JSON) {
        self.lon = json["longitude"].doubleValue
        self.lat = json["latitude"].doubleValue
        self.title = json["location"].stringValue
        self.depth = json["depth"].intValue
        self.strength = json["magnitude"].doubleValue
        self.location = json["location"].stringValue
        self.dateTime = json["date_time"].stringValue
    }
}
