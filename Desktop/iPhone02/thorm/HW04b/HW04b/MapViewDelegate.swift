//
//  MapViewDelegate.swift
//  HW04b
//
//  Created by Mark Thorogood on 5/13/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import MapKit

class MapViewDelegate: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    func getAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            requestAuthorization()
            // If status has not yet been determied, ask for authorization
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedAlways:
            // If always authorized
            break
        case .restricted:
            requestAuthorization()
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            requestAuthorization()
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
    
    func requestAuthorization() {
        let message = "You must authorize this app to always access your location in order for it to work."
        let title = "Action Required"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }))
    }
    
    func trackLocationsOn() {
        getAuthorization()
        
        // Clear all existing map overlays
        let overlays = mapView?.overlays
        mapView?.removeOverlays(overlays!)
        
        // Start updating locations
        locationManager.startUpdatingLocation()
        mapView?.showsUserLocation = true
    }
    
    func trackLocationsOff() {
        locationManager.stopUpdatingLocation()
        mapView?.showsUserLocation = false
    }
    
}
