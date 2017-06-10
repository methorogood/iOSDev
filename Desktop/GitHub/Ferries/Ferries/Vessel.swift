//
//  Vessel.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/4/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import CoreData

class Vessel: NSManagedObject {
    
    // Member properties
    @NSManaged var abbrevName: String
    @NSManaged var name: String
    @NSManaged var vesselID: Int16
    @NSManaged var lastLatitude: Double
    @NSManaged var lastLongitude: Double
    @NSManaged var lastPositionUpdateTime: Date
    
    // Relationship/s
    @NSManaged var toVesselClass: VesselClass?
    @NSManaged var toVesselDetails: VesselDetails?
    @NSManaged var toVesselPositionReport: VesselPositionReport?

    // Convenience property
    static var entityName: String { return "Vessel" }
    
    func printObject() {
        print("#### OBJECT: \(Vessel.entityName)")
        print("abbrevName: \(self.abbrevName)")
        print("name: \(self.name)")
        print("vesselID: \(self.vesselID)")
        print("lastLatitude: \(self.lastLatitude)")
        print("lastLongitude: \(self.lastLongitude)")
        print("lastPositionUpdateTime: \(self.lastPositionUpdateTime)")
    }
}
