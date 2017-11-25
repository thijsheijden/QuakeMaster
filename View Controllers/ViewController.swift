//
//  ViewController.swift
//  Quakes
//
//  Created by Thijs van der Heijden on 11/25/17.
//  Copyright © 2017 Thijs van der Heijden. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class ViewController: UIViewController {

    //Constants
    let URL: String = "https://earthquake-report.com/feeds/recent-eq?json"
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the initial location of the mapView
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        let regionRadius: CLLocationDistance = 10000000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
        getEarthquakeData(url: URL)
    }
    
    func getEarthquakeData(url: String) {
        //Sending a request to the openweather API
        Alamofire.request(URL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Earthquake data received succesfully")
                
                let earthquakeJSON : JSON = JSON(response.result.value!)
                self.updateEarthquakeData(json: earthquakeJSON)
                
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    
    func updateEarthquakeData(json : JSON) {
        
        let earthquakeArray = json.array!
        
        for entry in earthquakeArray {
            let long = entry["longitude"].doubleValue
            let lat = entry["latitude"].doubleValue
            let title = entry["title"].stringValue
            let depth = entry["depth"].intValue
            let strength = entry["magnitude"].doubleValue
            let location = entry["location"].stringValue
            
            let earthquake = EarthquakeModel(lat: lat, lon: long, strength: strength, depth: depth, title: title, location: location)
            print(earthquake)
        }
        
    }
    
    
    
}

