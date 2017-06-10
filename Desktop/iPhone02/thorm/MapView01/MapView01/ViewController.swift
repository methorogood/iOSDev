//
//  ViewController.swift
//  MapView01
//
//  Created by Mark Thorogood on 4/20/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    let userPreferences = UserPreferences()
    var mapViewDelegate = MapViewDelegate()
    
    // Used to store the location points
    let locationPoints: [CLLocation] = []
    

    @IBAction func saveData(_ sender: UIButton) {

    }
    var userAnnotationReference = [ReferencePoint]()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var switchMyLocation: UISwitch!
    @IBAction func switchMyLocation(_ sender: UISwitch) {
        if (switchMyLocation.isOn == true) {
            if (mapViewDelegate.isAuthorized() == false) {
                let alert = UIAlertController(title: "Location access not enabled", message: "To show your current location, you must grant this application access in Settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)
                switchMyLocation.isOn = false
            }
        }
        
        mapView.showsUserLocation = switchMyLocation.isOn
        userPreferences.myLocationSetting = switchMyLocation.isOn
    }
    
    @IBOutlet weak var switchTraffic: UISwitch!
    @IBAction func switchTraffic(_ sender: UISwitch) {
        print("Show Traffic: \(sender.isOn)")
        mapView.showsTraffic = sender.isOn
        userPreferences.trafficSetting = sender.isOn
    }
    
    @IBOutlet weak var switchPointOfInterest: UISwitch!
    @IBAction func switchPointOfInterest(_ sender: UISwitch) {
        print("Show Points of Interest: \(sender.isOn)")
        mapView.showsPointsOfInterest = sender.isOn
        userPreferences.pointsOfInterestSetting = sender.isOn
    }

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        defaults.set(sender.selectedSegmentIndex, forKey: UserPreferences.MAP_TYPE_KEY)
        setMapTypeMode(mapType: sender.selectedSegmentIndex)
        userPreferences.mapTypeSetting = sender.selectedSegmentIndex
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pass a reference to the mapViewDelegate so it has a handle to 
        // the object.
        mapViewDelegate.setMapView(mapView: mapView!)
        
        if let delegate = mapView.delegate as? MapViewDelegate {
            print(delegate.isAuthorized())
        }

        switchTraffic.isOn = userPreferences.trafficSetting
        switchPointOfInterest.isOn = userPreferences.pointsOfInterestSetting
        switchMyLocation.isOn = userPreferences.myLocationSetting
        segmentControl.selectedSegmentIndex = userPreferences.mapTypeSetting
        setMapTypeMode(mapType: userPreferences.mapTypeSetting)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        mapView.addGestureRecognizer(longPressRecognizer)
        
        
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.began {
            return
        }
        
        let touchPoint = gestureReconizer.location(in: mapView)
        let touchMapCoordinate = mapView?.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate!
        mapView.addAnnotation(annotation)
        
        let userAnnotation = ReferencePoint(latitude: (touchMapCoordinate?.latitude)!, longitude: (touchMapCoordinate?.longitude)!, title: "Location", subtitle: "location")
        
        userAnnotationReference.append(userAnnotation)

        print("Added user annotation to array")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Restore the view to its prior location
        let span:MKCoordinateSpan = MKCoordinateSpanMake(userPreferences.latitudeDeltaSetting, userPreferences.longitudeDeltaSetting)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(userPreferences.latitudeSetting, userPreferences.longitudeSetting)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



