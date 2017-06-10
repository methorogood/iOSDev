//
//  Vessel.swift
//  iOS2-HW05
//
//  Created by Mark Thorogood on 5/29/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import CoreData

class Vessel: NSManagedObject {
    
    @NSManaged var abbreviatedName: String
    @NSManaged var name: String
    @NSManaged var vesselID: Int16
    
    // Relationships
    @NSManaged var toVesselClass: VesselClass
    @NSManaged var toVesselDetail: VesselDetail
    @NSManaged var positionReports: NSSet?
    
    static var entityName: String { return "Vessel" }
}
