//
//  ViewController.swift
//  mapApp
//
//  Created by Qiankang Zhou on 8/21/17.
//  Copyright © 2017 team_lk. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,  CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var navgationButton: UIBarButtonItem!
    @IBAction func navigateTapped(_ sender: Any) {
        if isNavigating {
            myMap.removeOverlays(myMap.overlays)
            isNavigating = false
            setRegionToUserLocation()
            self.navgationButton.title = "Navigation"
            return
        } else {
            guard self.currAnnotation != nil
                else {
                return
            }
            self.navgationButton.title = "Stop Navigation"
            self.isNavigating = true
        }
        showRoute()
    }
    
    func showRoute(){
        myMap.removeOverlays(myMap.overlays)
        guard let annotaion = currAnnotation
            else {
                print("No annotation selected")
                return
        }
        guard let location = currentLocation
            else {
                return
        }
        let source = MKPlacemark(coordinate: location.coordinate)
        let destination = MKPlacemark(coordinate: annotaion.coordinate)
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: source)
        directionRequest.destination = MKMapItem(placemark: destination)
        directionRequest.transportType = .automobile
        
        let direction = MKDirections(request: directionRequest)
        direction.calculate(completionHandler: {
            response, error in
            guard let response = response
                else {
                    if let error = error {
                        print(error)
                    }
                    return
            }
            let route = response.routes[0]
            self.myMap.add(route.polyline, level: .aboveRoads)
            
            var start = route.polyline.boundingMapRect
            start.size.width *= 1.3
            start.size.height *= 1.3
            start.origin.x -= start.size.width * 0.15
            start.origin.y -= start.size.height * 0.15
            self.myMap.setRegion(MKCoordinateRegionForMapRect(start), animated: true)
        })
    }
    
    func updateAllAnnotations() {
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.green
        renderer.lineWidth = 5.0
        isNavigating = true
        return renderer
    }
    
    @IBOutlet weak var myMap: MKMapView!
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var span = MKCoordinateSpanMake(0.035, 0.035)
    var initSet = false
    var allAnnotation : [MKAnnotation] = []
    var currAnnotation : MKAnnotation?
    var isNavigating = false
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if !isNavigating {
            self.currAnnotation = nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view.annotation != nil
            else {
                print("No annotation")
                return
        }
        self.currAnnotation = view.annotation!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        myMap.delegate = self
        locationManager?.delegate = self
        myMap.userTrackingMode = .follow
        locationPermissin()
        initAltLocation()
        showCompass()
        showTrackingButton()
        updateAllAnnotation()
    }
    
    func updateAllAnnotation(){
        myMap.removeAnnotations(myMap.annotations)
        for addr in addressDictionary.keys {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(addressDictionary[addr] ?? "") {
                (placemarks, error) in
                guard let placemark = placemarks?.first
                    else {
                    print("GeoCoder fail")
                    return
                }
                let lat = placemark.location?.coordinate.latitude
                let lon = placemark.location?.coordinate.longitude
                let annotation = MKPointAnnotation()
                annotation.title = "\(availabilityDictionary[addr] ?? 0)"
                annotation.subtitle = addr.description
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                self.myMap.addAnnotation(annotation)
                self.allAnnotation.append(annotation)
            }
        }
    }
    
    func initAltLocation() {
        let altLocation = CLLocationCoordinate2D(latitude: 43.0731, longitude: -89.4012)
        let region = MKCoordinateRegion(center: altLocation, span: span)
        myMap.setRegion(region, animated: true)
        myMap.showsUserLocation = true
    }
    
    func showTrackingButton() {
        let button = MKUserTrackingButton(mapView: myMap)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3), button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3)])
    }
    
    func showCompass() {
        let compass = MKCompassButton(mapView: myMap)
        compass.compassVisibility = .visible
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        myMap.showsCompass = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let button = MKUserTrackingButton(mapView: myMap)
        self.view.addSubview(button)
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
            if !initSet {
                setRegionToUserLocation()
                initSet = true
            }
            if isNavigating {
                showRoute()
            }
        }
    }
    
    func setRegionToUserLocation() {
        guard let userLocation = currentLocation
            else {
            return
        }
        let center = userLocation.coordinate
        let region = MKCoordinateRegion(center: center, span: span)
        myMap.setRegion(region, animated: true)
    }
}


