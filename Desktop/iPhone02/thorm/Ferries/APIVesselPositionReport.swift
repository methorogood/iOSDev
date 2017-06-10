//
//  APIPositionReport.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/5/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation

class APIVesselPositionReport {
    
    var heading: Double
    var latitude: Double
    var longitude: Double
    var speed: Double
    var timeStamp: Date? {
        get {
            return Date(jsonDate: rawTimeStampAsString)
        }
    }
    
    var rawTimeStampAsString: String
    var vesselID: Int16
    
    static var entityName: String { return "APIVesselPositionReport" }
    
    init() {
        self.heading = -1
        self.latitude = -1
        self.longitude = -1
        self.speed = -1
        self.rawTimeStampAsString = ""
        self.vesselID = -1
    }
    
    func printObject() {
        print("#### OBJECT: \(APIVesselPositionReport.entityName)")
        print("heading: \(self.heading)")
        print("latitude: \(self.latitude)")
        print("longitude: \(self.longitude)")
        print("speed: \(self.speed)")
        if let objTime = timeStamp {
            print("timeStamp: \(objTime)")
        } else {
            print("timeStamp is nil")
        }
        print("Timestamp as String: \(self.rawTimeStampAsString)")
        print("Vessel ID: \(vesselID)")
    }
}


extension Date {
    
    init?(jsonDate: String) {
        
        let tokens:[String] = Utilities.matches(for: "[0-9]+", in: jsonDate)
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        
        if tokens.count < 2 {
            fatalError()
        }
        
        // Extract tokens from match.
        let token01 = formatter.number(from: tokens[0])
        let token02 = formatter.number(from: tokens[1])

        // Convert milliseconds to seconds.
        let totalSeconds = (token01! as! Double) / 1000.0
        
        // Convert hour offset from GMT.
        let hoursOffset = (token02! as! Double) / 100.0
        
        // Calculate the total number of seconds.
        let secondsSince1970: Double = totalSeconds - (hoursOffset * 3600)
        
        self.init(timeIntervalSince1970: secondsSince1970)
    }
}
