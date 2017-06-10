//
//  APIVessel.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/5/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation

class APIVessel {
    var abbrevName: String
    var vesselClassName: String
    var name: String
    var vesselID: Int16
    
    static var entityName:String { return "APIVessel" }
    
    init() {
        self.abbrevName = ""
        self.vesselClassName = ""
        self.name = ""
        self.vesselID = -1
    }
    
    func printOut() {
        print("#### OBJECT: \(APIVessel.entityName)")
        print("abbrevName: \(self.abbrevName)")
        print("vesselClassName: \(self.vesselClassName)")
        print("name: \(self.name)")
        print("vesselID: \(self.vesselID)")
    }
}
