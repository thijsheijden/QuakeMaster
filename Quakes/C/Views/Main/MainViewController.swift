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

final class MainViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak private var mapView: MKMapView!
    
    // MARK: Constants and variables
    private let URL: String = "https://earthquake-report.com/feeds/recent-eq?json"
    private var earthquakePin: EarthquakePin!
    private var earthquakeImage: String!
    private var image: String!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup mapView
        mapView.mapType = .hybridFlyover
        
        // setting the initial location of the mapView
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        let regionRadius: CLLocationDistance = 10000000
        centerMapOnLocation(location: initialLocation, regionRadius: regionRadius)
        getEarthquakeData(url: URL)
    }
    
    // MARK: IBActions
    @IBAction func refreshButtonTapped(_ sender: Any) {
        getEarthquakeData(url: URL)
    }
    
    // MARK: Helper functions
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func getEarthquakeData(url: String) {
        // Get the json response from the openweather API using Alamofire
        Alamofire.request(URL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Earthquake data received succesfully")
                
                let earthquakeJSON = JSON(response.result.value!)
                self.updateEarthquakeData(json: earthquakeJSON)
                
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    
    private func updateEarthquakeData(json: JSON) {
        guard let earthquakeArray = json.array else { return }
        
        for earthquake in earthquakeArray {
            
            // Create objects from json data
            let earthquake = EarthquakeModel(json: earthquake)
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(earthquake.lat, earthquake.lon)
            
            // create and add pin to the map
            earthquakePin = EarthquakePin(title: earthquake.title, subtitle: "\(earthquake.strength) on the scale of Richter on \(earthquake.dateTime)", coordinate: coordinate)
            mapView.addAnnotation(earthquakePin)
        }
    }
    
}
