//
//  MapViewDataManager.swift
//  HW02
//
//  Created by Mark Thorogood on 4/30/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit
import CoreLocation

// Performs basic CRUD operations for map data.
class MapViewDataManager: NSObject {
    
    // Used as a singleton instance.
    let sharedInstance = MapViewDataManager()
    
    var locationHistory: [CLLocation] = []

    override init() {
        super.init()
        
        // Register an observer to listen for map view updates.
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLocationHistoryData(_:)), name: NSNotification.Name(rawValue: "controllerUpdateLocationHistory"), object: nil)
    }
    
    func updateLocationHistoryData(_ notification: NSNotification) {
        if let unwrappedDataUpdate = notification.userInfo?["dataKey"] as? [CLLocation] {
            // Update the model.
            locationHistory.append(contentsOf: unwrappedDataUpdate)
            
            // Notify all observers that a location history update occurred.
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modelUpdateLocationHistory"), object: nil, userInfo: ["dataKey": locationHistory])
        }
    }
    
    func deleteLocationHistory() {
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: locationHistoryFilePath()) {
                try fileManager.removeItem(atPath: locationHistoryFilePath())
                print("Deleted history; \(locationHistoryFilePath())")
            }
        } catch let error as NSError {
            print("Error in deleting file history; \(error.debugDescription)")
        }
    }
    
    func fetchLocationHistory() -> [CLLocation]? {
        if let unarchivedLocationHistory = NSKeyedUnarchiver.unarchiveObject(withFile: locationHistoryFilePath()) as? [CLLocation] {
            print("Fetched file history from \(locationHistoryFilePath())")
            return unarchivedLocationHistory
        } else {
            return nil
        }
    }

    func saveLocationHistory(locationHistory: [CLLocation]) {
        NSKeyedArchiver.archiveRootObject(locationHistory, toFile: locationHistoryFilePath())
        print("Saved file history to \(locationHistoryFilePath())")
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
