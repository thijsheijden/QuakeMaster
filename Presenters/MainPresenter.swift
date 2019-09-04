//
//  MainPresenter.swift
//  Quakes
//
//  Created by Thijs van der Heijden on 04/09/2019.
//  Copyright © 2019 Thijs van der Heijden. All rights reserved.
//

import Foundation

class MainPresenter: PresenterProtocol {
    var view: ViewControllerProtocol
    
    required init(view: ViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view.setInitialMapLocation()
        updateEarthquakeData()
    }
    
    typealias viewControllerProtocol = ViewControllerProtocol
    
    func updateEarthquakeData() {
        
        func getAnnotationImage(magnitude: String) -> String {
            guard let magnitudeDouble = Double(magnitude) else {return "error"}
            
            switch magnitudeDouble {
            case 0...5:
                return "1"
            case 5...6:
                return "2"
            case 6...10:
                return "3"
            default:
                return "Too strong"
            }
        }
        
        earthquakeDataRequest(completion: { earthquakeData in
            
            var earthquakes: [EarthquakePin] = [EarthquakePin]()
            
            for earthquake in earthquakeData {
                let pin = EarthquakePin(title: earthquake.title, subtitle: "", lat: Double(earthquake.latitude)!, lon: Double(earthquake.longitude)!, image: getAnnotationImage(magnitude: earthquake.magnitude))
                earthquakes.append(pin)
            }
            
            self.view.updatePins(earthquakePins: earthquakes)
        })
    }
}
