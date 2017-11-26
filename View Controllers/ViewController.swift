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

    //MARK: Global constants, variables, outlets and actions
    //global constants and variables
    let URL: String = "https://earthquake-report.com/feeds/recent-eq?json"
    var earthquakePin: EarthquakePin!
    var earthquakeImage: String!
    var image: String!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func refreshButtonTapped(_ sender: Any) {
        getEarthquakeData(url: URL)
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.mapType = .hybridFlyover
        
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
    
    //MARK: Sending a request to the JSON data on the server using Alamofire
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
    
    //MARK: JSON Parsing
    func updateEarthquakeData(json : JSON) {
        
        //Creating an array from the JSON data
        let earthquakeArray = json.array!
        
        //Looping through the array looking for items needed
        for entry in earthquakeArray {
            let long = entry["longitude"].doubleValue
            let lat = entry["latitude"].doubleValue
            let title = entry["location"].stringValue
            let depth = entry["depth"].intValue
            let strength = entry["magnitude"].doubleValue
            let location = entry["location"].stringValue
            let dateTime = entry["date_time"].stringValue
            
            //Adding the information found to a new constant called "Earthquake", built from the EarthquakeModel class
            let earthquake = EarthquakeModel(lat: lat, lon: long, strength: strength, depth: depth, title: title, location: location, dateTime: dateTime)
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(earthquake.lat, earthquake.lon)
            
            //Adding all the earthquake pins to the map with their corresponding title and subtitle
            earthquakePin = EarthquakePin(title: earthquake.title, subtitle: "\(earthquake.strength) on the scale of Richter on \(dateTime)", coordinate: coordinate)
            mapView.addAnnotation(earthquakePin)
            
        }
    }
    
}

