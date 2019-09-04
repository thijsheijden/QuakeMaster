//
//  EarthquakeDataStruct.swift
//  Quakes
//
//  Created by Thijs van der Heijden on 04/09/2019.
//  Copyright © 2019 Thijs van der Heijden. All rights reserved.
//

import Foundation

// MARK: - EarthquakeDataStructElement
struct EarthquakeDataStructElement: Codable {
    let title, magnitude, location, depth: String
    let latitude, longitude: String
    let dateTime: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case title, magnitude, location, depth, latitude, longitude
        case dateTime = "date_time"
        case link
    }
}

typealias EarthquakeDataStruct = [EarthquakeDataStructElement]
