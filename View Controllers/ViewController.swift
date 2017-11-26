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

class ViewController: UIViewController, MKMapViewDelegate {

    //global constants and variables
    let URL: String = "https://earthquake-report.com/feeds/recent-eq?json"
    var earthquakePin: EarthquakePin!
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func refreshButtonTapped(_ sender: Any) {
        getEarthquakeData(url: URL)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
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
        
        //Creating an array from the JSON data
        let earthquakeArray = json.array!
        
        //Looping through the array looking for items needed
        for entry in earthquakeArray {
            let long = entry["longitude"].doubleValue
            let lat = entry["latitude"].doubleValue
            let title = entry["title"].stringValue
            let depth = entry["depth"].intValue
            let strength = entry["magnitude"].doubleValue
            let location = entry["location"].stringValue
            
            var image: String!
            
            if strength < 4.0 {
                image = "1"
            } else if strength >= 4.0 {
                image = "2"
            } else {
                image = "3"
            }
            
            //Adding the information found to a new constant called "Earthquake", built from the EarthquakeModel class
            let earthquake = EarthquakeModel(lat: lat, lon: long, strength: strength, depth: depth, title: title, location: location, image: image)
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(earthquake.lat, earthquake.lon)
            
            earthquakePin = EarthquakePin(title: earthquake.title, subtitle: "\(earthquake.strength) on the scale of Richter", coordinate: coordinate)
            mapView.addAnnotation(earthquakePin)
            
            mapView(mapView, viewFor: earthquakePin)
            
            

            //Placing all the earthquake constants on the map
//            let earthquakeLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(earthquake.lat, earthquake.lon)
//            let earthquakeAnnotation = MKPointAnnotation()
//            earthquakeAnnotation.coordinate = earthquakeLocation
//            earthquakeAnnotation.title = earthquake.title
//            earthquakeAnnotation.subtitle = "\(earthquake.strength) on the scale of Richter"
//            mapView.addAnnotation(earthquakeAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: earthquakePin, reuseIdentifier: "eartquakePin")
        annotationView.image = UIImage(named: "1")
        return annotationView
    }
    
}

