//
//  ViewController.swift
//  mapApp
//
//  Created by Qiankang Zhou on 8/21/17.
//  Copyright © 2017 team_lk. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,  CLLocationManagerDelegate{
    
    @IBOutlet weak var myMap: MKMapView!
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationPermissin()
        let center = currentLocation?.coordinate
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let altLocation = CLLocationCoordinate2D(latitude: 43.0731,
                                                 longitude: -89.4012)
        let region = MKCoordinateRegion(center: center ?? altLocation, span: span)
        myMap.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationPermissin() {
        locationManager?.requestAlwaysAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currLocation = locations.first {
            currentLocation = currLocation
        }
    }
}


