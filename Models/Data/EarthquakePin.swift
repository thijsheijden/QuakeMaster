//
//  earthquakePin.swift
//  Quakes
//
//  Created by Thijs van der Heijden on 11/26/17.
//  Copyright © 2017 Thijs van der Heijden. All rights reserved.
//

import MapKit

class EarthquakePin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage
    
    init(title: String, subtitle: String, lat: Double, lon: Double, image: String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.image = UIImage(named: image)!
    }
}
