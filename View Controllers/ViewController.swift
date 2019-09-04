//
//  ViewController.swift
//  Quakes
//
//  Created by Thijs van der Heijden on 11/25/17.
//  Copyright © 2017 Thijs van der Heijden. All rights reserved.
//

import UIKit
import MapKit

protocol ViewControllerProtocol {
    func setupPresenter()
    func setInitialMapLocation()
    func updatePins(earthquakePins: [EarthquakePin])
}

class ViewController: UIViewController, MKMapViewDelegate, ViewControllerProtocol {

    var earthquakePin: EarthquakePin!
    var earthquakeImage: String!
    var image: String!
    var presenter: MainPresenter!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        presenter.updateEarthquakeData()
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPresenter()
        
        mapView.delegate = self
        mapView.mapType = .hybridFlyover
    }
    
    func setupPresenter() {
        presenter = MainPresenter(view: self)
        presenter.viewDidLoad()
    }
    
    func setInitialMapLocation() {
        //setting the initial location of the mapView
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        let regionRadius: CLLocationDistance = 10000000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
    }
    
    func updatePins(earthquakePins: [EarthquakePin]) {
        mapView.addAnnotations(earthquakePins)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let earthquakePin = annotation as? EarthquakePin {
            let annotationView = MKAnnotationView(annotation: earthquakePin, reuseIdentifier: "annotationViewReuseIdentifier")
            
            let size = CGSize(width: 40, height: 40)
            UIGraphicsBeginImageContext(size)
            earthquakePin.image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            annotationView.image = resizedImage
            annotationView.canShowCallout = true
            return annotationView
        }
        return nil
    }
}

