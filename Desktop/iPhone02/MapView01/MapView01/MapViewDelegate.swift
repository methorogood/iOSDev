//
//  MapViewDelegate.swift
//  MapView01
//
//  Created by Mark Thorogood on 4/20/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit
import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let userPreferences = UserPreferences()
    
    public override init () {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Examines whether the application is authorized to use location services.
    // If not, it requests authorization.  If not authorized at the end of the 
    // evaluation, the function returns false.
    func isAuthorized() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            locationManager.startUpdatingLocation()
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
        
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            return true
        } else {
            return false
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // May want to put authorization code here.
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("region did change")
        userPreferences.latitudeSetting = mapView.region.center.latitude
        userPreferences.longitudeSetting = mapView.region.center.longitude
        userPreferences.latitudeDeltaSetting = mapView.region.span.latitudeDelta
        userPreferences.longitudeDeltaSetting = mapView.region.span.longitudeDelta
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let location = userLocation.coordinate
        let span:MKCoordinateSpan = MKCoordinateSpanMake(userPreferences.latitudeDeltaSetting, userPreferences.longitudeDeltaSetting)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
    }

}

