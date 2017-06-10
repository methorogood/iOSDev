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
    
    @IBOutlet weak var mapView: MKMapView!
    

    @IBOutlet weak var btnDeleteHistory: UIButton!
    @IBAction func btnDeleteHistory(_ sender: UIButton) {
        if let delegate = mapView.delegate as? MapViewDelegate {
            delegate.deleteLocationHistory()
            let alert = UIAlertController(title: "Location Tracker", message: "Deleted tracking history.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    

    @IBOutlet weak var btnRestoreHistory: UIButton!
    @IBAction func btnRestoreHistory(_ sender: UIButton) {
        if let delegate = mapView.delegate as? MapViewDelegate {
            delegate.restoreLocationHistory()
            let alert = UIAlertController(title: "Location Tracker", message: "Restored location history from file.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    
    @IBOutlet weak var btnSaveHistory: UIButton!
    @IBAction func btnSaveHistory(_ sender: UIButton) {
        if let delegate = mapView.delegate as? MapViewDelegate {
            let alert = UIAlertController(title: "Location Tracker", message: "Saved tracking history.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            delegate.saveLocationHistory()
        }
    }
    
    @IBOutlet weak var btnTrackHistory: UIButton!
    @IBAction func btnTrackHistory(_ sender: UIButton) {
        if (trackingLocations == true) {
            trackingLocations = false
            btnTrackHistory.setTitle("Track Off", for: .normal)
            if let delegate = mapView.delegate as? MapViewDelegate {
                delegate.trackLocationsOff()
            }
        } else {
            trackingLocations = true
            btnTrackHistory.setTitle("Track On", for: .normal)
            if let delegate = mapView.delegate as? MapViewDelegate {
                delegate.trackLocationsOn()
            }
        }
    }
    
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    let userPreferences = UserPreferences()
    
    // Used to store the location points
    let locationPoints: [CLLocation] = []

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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let delegate = mapView.delegate as? MapViewDelegate {
            delegate.trackLocationsOff()
        }
    }
    
    func processLocationHistoryUpdate(_ notification: NSNotification) {
        if let unwrappedData = notification.userInfo?["dataKey"] as? [CLLocation] {
            print(dump(unwrappedData))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register an observer to listen for modelUpdates
        NotificationCenter.default.addObserver(self, selector: #selector(self.processLocationHistoryUpdate(_:)), name: NSNotification.Name(rawValue: "modelUpdateLocationHistory"), object: nil)
        
        btnDeleteHistory.layer.cornerRadius = 5
        btnDeleteHistory.layer.borderWidth = 1
        btnDeleteHistory.layer.borderColor = UIColor.blue.cgColor
        
        btnRestoreHistory.layer.cornerRadius = 5
        btnRestoreHistory.layer.borderWidth = 1
        btnRestoreHistory.layer.borderColor = UIColor.blue.cgColor
        
        btnSaveHistory.layer.cornerRadius = 5
        btnSaveHistory.layer.borderWidth = 1
        btnSaveHistory.layer.borderColor = UIColor.blue.cgColor
        
        btnTrackHistory.layer.cornerRadius = 5
        btnTrackHistory.layer.borderWidth = 1
        btnTrackHistory.layer.borderColor = UIColor.blue.cgColor
        
        // Pass a reference of the mapView to the MapViewDelegate
        // object.
        if let delegate = mapView.delegate as? MapViewDelegate {
            delegate.setMapViewReference(mapView: self.mapView!)
            delegate.getAuthorization()
        }
        
        mapType.selectedSegmentIndex = userPreferences.mapTypeSetting
        
        setMapTypeMode(mapType: userPreferences.mapTypeSetting)
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

