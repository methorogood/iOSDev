//
//  MapDataManager.swift
//  MapView01
//
//  Created by Mark Thorogood on 4/26/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import CoreLocation

// This class will be implemented as a singleton.
class MapDataManager: NSObject {
    
    //
    static let shared = MapDataManager()
    let locationManager = CLLocationManager()
    var locationHistory = [CLLocation]()
    

    func saveUserData() {
        NSKeyedArchiver.archiveRootObject(locationHistory, toFile: locationHistoryFilePath())
    }
    
    func fetchUserData() {
        //        let unarchivedHistory = NSKeyedUnarchiver.unarchiveObject(withFile: locationHistoryFilePath()) as? [ReferencePoint]
        // TO DO:  Need to fix this item
    }
    
    func applicationDocumentsDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }
    
    func locationHistoryFilePath() -> String {
        let resultURL = applicationDocumentsDirectory().appendingPathComponent("location.data")
        return resultURL.path
    }
}
