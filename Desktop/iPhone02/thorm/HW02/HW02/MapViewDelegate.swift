//
//  MapViewDelegate.swift
//  HW02
//
//  Created by Mark Thorogood on 4/28/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit
import MapKit

class MapViewDelegate: NSObject, CLLocationManagerDelegate, MKMapViewDelegate  {
    let locationTrackingHistoryKey = "locationTrackingHistoryKey"
    
    // The following redirection is not required for this assignment,
    // but it provides a level of abstraction to switch out the data 
    // management functions without disturbing the MapViewDelegate.
    let dataManager = MapViewDataManager()
    let locationManager = CLLocationManager()
    let userPreferences = UserPreferences()
    var locationHistory: [CLLocation] = []
    var latitudeDelta: Double = UserPreferences().latitudeDeltaSetting
    var longitudeDelta: Double = UserPreferences().longitudeDeltaSetting
    
    func processTrackingHistory(update: CLLocation) {
        
    }
    
    
    weak var mapView: MKMapView?
    
    func deleteLocationHistory() {
       dataManager.deleteLocationHistory()
    }
    
    func restoreLocationHistory() {
        let overlays = mapView!.overlays
        mapView!.removeOverlays(overlays)
        if let restoredLocationHistory = dataManager.fetchLocationHistory() {
            drawLocationHistory(locationHistory: restoredLocationHistory)
        }
    }
    
    func saveLocationHistory() {
        dataManager.saveLocationHistory(locationHistory: locationHistory)
    }
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation
    }
    
    func getAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
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
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // debugPrint(locations.last as Any)
        // locationHistory.append(contentsOf: locations)
        // drawLocationHistory(locationHistory: locationHistory)
        
        // Send map data update to the map data model (i.e. MapViewDataManager)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "controllerUpdateLocationHistory"), object: nil, userInfo: ["dataKey": locations])
    }
    
    
    func drawLocationHistory(locationHistory: [CLLocation]) {
        // Create an array of location coordinates from the location history.
        var coordinates: [CLLocationCoordinate2D] = []
        for location in locationHistory {
            coordinates.append(location.coordinate)
        }
        
        let line: MKPolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        self.mapView?.add(line)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Returns a renderer to draw the polyline on a map
        let polylinerenderer = MKPolylineRenderer(overlay: overlay)
        if overlay is MKPolyline {
            polylinerenderer.strokeColor = UIColor.blue
            polylinerenderer.lineWidth = 5
        }
        return polylinerenderer
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        userPreferences.latitudeSetting = mapView.region.center.latitude
        userPreferences.longitudeSetting = mapView.region.center.longitude
        userPreferences.latitudeDeltaSetting = mapView.region.span.latitudeDelta
        userPreferences.longitudeDeltaSetting = mapView.region.span.longitudeDelta
        self.latitudeDelta = mapView.region.span.latitudeDelta
        self.longitudeDelta = mapView.region.span.longitudeDelta
    }
    
    // Set a reference to the mapView object.
    func setMapViewReference(mapView: MKMapView) {
        self.mapView = mapView
    }

    
    func trackLocationsOn() {
        getAuthorization()
        // Clear the history to start tracking at current location.
        locationHistory.removeAll()
        
        // Clear all existing map overlays
        let overlays = mapView?.overlays
        mapView?.removeOverlays(overlays!)
        
        // Start updating locations
        locationManager.startUpdatingLocation()
        mapView?.showsUserLocation = true
        
        // Center map on tracked location
        let currentCoordinate = locationManager.location?.coordinate
        let currentSpan = MKCoordinateSpan(latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta)
        let coordinateRegion = MKCoordinateRegionMake(currentCoordinate!, currentSpan)
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    
    func trackLocationsOff() {
        locationManager.stopUpdatingLocation()
        mapView?.showsUserLocation = false
    }
    
}


