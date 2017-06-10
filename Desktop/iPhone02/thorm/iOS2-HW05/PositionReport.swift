//
//  PositionReport.swift
//  iOS2-HW05
//
//  Created by Mark Thorogood on 5/29/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import CoreData

class PositionReport: NSManagedObject {
    @NSManaged var heading: Double
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var speed: Double
    
    @NSManaged var toVessel: Vessel
}
