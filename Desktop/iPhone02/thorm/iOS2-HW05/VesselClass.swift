//
//  VesselClass.swift
//  iOS2-HW05
//
//  Created by Mark Thorogood on 5/29/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import CoreData

class VesselClass: NSManagedObject {
    // Object member/s
    @NSManaged var name: String
    
    // Relationship/s
    @NSManaged var vessels: NSSet?
    
    // Convenience property
    static var entityName: String { return "VesselClass" }
}
