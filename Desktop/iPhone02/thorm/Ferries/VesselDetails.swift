//
//  VesselDetails.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/6/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import CoreData

class VesselDetails: NSManagedObject {
    
    // Object properties.
    @NSManaged var drawingURL: String
    @NSManaged var history: String
    @NSManaged var length: String
    @NSManaged var nameDescription: String
    @NSManaged var vesselID: Int16
    
    // Relationship.
    @NSManaged var toVessel: Vessel?
    
    // Convenience property.
    static var entityName: String { return "VesselDetails" }
    
    // Convenience method.
    func printObject() {
        print("#### OBJECT: \(VesselDetails.entityName)")
        print("drawingURL: \(self.drawingURL)")
        print("history: \(self.history)")
        print("length: \(self.length)")
        print("nameDescription: \(self.nameDescription)")
        print("vesselID: \(self.vesselID)")
    }
}
