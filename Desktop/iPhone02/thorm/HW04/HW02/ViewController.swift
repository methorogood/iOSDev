//
//  ViewController.swift
//  HW02
//
//  Created by Mark Thorogood on 4/28/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    var trackingLocations: Bool = false
    let iCloudKeyStore = NSUbiquitousKeyValueStore()
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let dataModel = MapViewDataManager()
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    let userPreferences = UserPreferences()
    
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBAction func mapType(_ sender: UISegmentedControl) {
        defaults.set(sender.selectedSegmentIndex, forKey: UserPreferences.MAP_TYPE_KEY)
        setMapTypeMode(mapType: sender.selectedSegmentIndex)
        userPreferences.mapTypeSetting = sender.selectedSegmentIndex
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Restore the view to its prior location
        let span:MKCoordinateSpan = MKCoordinateSpanMake(userPreferences.latitudeDeltaSetting, userPreferences.longitudeDeltaSetting)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(userPreferences.latitudeSetting, userPreferences.longitudeSetting)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        // Start tracking location.
        if let delegate = mapView.delegate as? MapViewDelegate {
            delegate.trackLocationsOn()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    func processLocationHistoryUpdate(_ notification: NSNotification) {
        if let unwrappedData = notification.userInfo?["dataKey"] as? [CLLocation] {
            drawLocationHistory(locationHistory: unwrappedData)
        }
    }
    
    func drawLocationHistory(locationHistory: [CLLocation]) {
        if let delegate = mapView.delegate as? MapViewDelegate {
            delegate.drawLocationHistory(locationHistory: locationHistory)
        }
    }
    
    func saveMapTypeToiCloud(mapType: Int64) {
        iCloudKeyStore.set(mapType, forKey: "MapType")
        iCloudKeyStore.synchronize()
        print("Saved to iCloud")
    }
    
    func getMapTypeFromiCloud() -> Int {
        return Int(iCloudKeyStore.longLong(forKey: "MapType"))
    }
    
    func handleKeyValueDidChange(_ notification: NSNotification) -> Int {
        let mapType = iCloudKeyStore.longLong(forKey: "MapType")
        print("Map type from iCloud: \(mapType)")
        userPreferences.mapTypeSetting = Int(mapType)
        defaults.set(mapType, forKey: UserPreferences.MAP_TYPE_KEY)
        setMapTypeMode(mapType: userPreferences.mapTypeSetting)
        return getMapTypeFromiCloud()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Register an observer to listen for modelUpdates
        NotificationCenter.default.addObserver(self, selector: #selector(self.processLocationHistoryUpdate(_:)), name: NSNotification.Name(rawValue: "modelUpdateLocationHistory"), object: nil)
        
        // Pass a reference of the mapView to the MapViewDelegate
        // object.
        if let delegate = mapView.delegate as? MapViewDelegate {
            delegate.setMapViewReference(mapView: self.mapView!)
            delegate.getAuthorization()
            if let currentLocation = dataModel.initLocationHistory() {
                mapView.setCenter(currentLocation.coordinate, animated: true)
            }
        }
        
        mapType.selectedSegmentIndex = userPreferences.mapTypeSetting
        setMapTypeMode(mapType: userPreferences.mapTypeSetting)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handleKeyValueDidChange(_:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: iCloudKeyStore)
        
        iCloudKeyStore.synchronize()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMapTypeMode(mapType: Int) {
        switch(mapType) {
        case 0:
            mapView.mapType = MKMapType.standard
        case 1:
            mapView.mapType = MKMapType.hybrid
        case 2:
            mapView.mapType = MKMapType.satellite
        default:
            fatalError()
        }
    }


}

