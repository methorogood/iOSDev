//
//  VesselClass.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/4/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import CoreData

class VesselClass: NSManagedObject {
    
    // Member properties.
    @NSManaged var name: String
    
    // Relationships.
    @NSManaged var vessels: NSSet?
    
    // Convenience property.
    static var entityName: String { return "VesselClass" }
    
    // Convenience method.
    func printObject() {
        print("#### OBJECT: \(VesselClass.entityName)")
        print("name: \(self.name)")
    }
    
}
