//
//  ViewController.swift
//  HW04b
//
//  Created by Mark Thorogood on 5/13/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    let iCloudKeyStore = NSUbiquitousKeyValueStore()
    var mapType: Int = 0
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var segmentMapViewType: UISegmentedControl!
    @IBAction func segmentMapViewType(_ sender: UISegmentedControl) {
        setMapTypeMode(mapType: sender.selectedSegmentIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handleKeyValueDidChange(_:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: iCloudKeyStore)
        
        iCloudKeyStore.synchronize()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleKeyValueDidChange(_ notification: NSNotification) {
        print("keyhandle did change")
        let mapType = iCloudKeyStore.longLong(forKey: "MapType")
        setMapTypeMode(mapType: Int(mapType))
    }

    
    func saveToiCloud(mapType: Int) {
        iCloudKeyStore.set(mapType, forKey: "MapType")
        iCloudKeyStore.synchronize()
        print("Saved to iCloud")
    }
    
    
    func setMapTypeMode(mapType: Int) {
        saveToiCloud(mapType: mapType)
        segmentMapViewType.selectedSegmentIndex = mapType
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

