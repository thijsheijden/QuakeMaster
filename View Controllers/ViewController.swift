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
    let URL: String = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson"
    let earthquakeModel = EarthquakeModel()
    
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
        earthquakeModel.lon = json["features"][0]["geometry"]["coordinates"][0].doubleValue
        earthquakeModel.lat = json["features"][0]["geometry"]["coordinates"][1].doubleValue
        earthquakeModel.strength = json["features"][0]["properties"]["mag"].doubleValue
        earthquakeModel.place = json["features"][0]["properties"]["place"].stringValue
        
        print(earthquakeModel.lat, earthquakeModel.lon)
        
        let earthquakeLocation = CLLocationCoordinate2D(latitude: earthquakeModel.lat, longitude: earthquakeModel.lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = earthquakeLocation
        annotation.title = "Earthquake \(earthquakeModel.place)"
        annotation.subtitle = "\(earthquakeModel.strength) on the scale of Richter"
        
        mapView.addAnnotation(annotation)
    }
    
    
    
}

