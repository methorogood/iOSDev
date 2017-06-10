//
//  VesselPositionReport.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/6/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import CoreData

class VesselPositionReport: NSManagedObject {
    
    // Object properties.
    @NSManaged var heading: Double
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var speed: Double
    @NSManaged var timeStamp: Date?
    @NSManaged var vesselID: Int16
    
    // Relationship.
    @NSManaged var toVessel: Vessel
    
    // Convenience method.
    static var entityName: String { return "VesselPositionReport" }
    
    // Convenience function.
    func printObject() {
        print("#### OBJECT: \(VesselPositionReport.entityName)")
        print("heading: \(self.heading)")
        print("latitude: \(self.latitude)")
        print("longitude: \(self.longitude)")
        print("speed: \(self.speed)")
        if self.timeStamp != nil {
            print("timeStamp: \(self.timeStamp!)")
        }
        print("vesselID: \(self.vesselID)")
    }

}
