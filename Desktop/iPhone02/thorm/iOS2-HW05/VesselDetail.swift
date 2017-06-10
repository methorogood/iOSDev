//
//  VesselDetail.swift
//  iOS2-HW05
//
//  Created by Mark Thorogood on 5/29/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import CoreData

class VesselDetail: NSManagedObject {
    // Member properties
    @NSManaged var drawingURL: String
    @NSManaged var history: String
    @NSManaged var length: Double
    @NSManaged var nameDescription: String
    
    // Relationship/s
    @NSManaged var toVessel: Vessel
    
    // Convenience methods.
    static var entityName: String { return "VesselDetail" }
}
