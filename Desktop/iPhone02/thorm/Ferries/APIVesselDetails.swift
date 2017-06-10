//
//  APIVesselDetail.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/5/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation

class APIVesselDetails {
    var drawingURL: String
    var history: String
    var length: String
    var nameDescription: String
    var vesselID: Int16
    
    static var entityName:String { return "APIVesselDetails" }
    
    init() {
        self.drawingURL = ""
        self.history = ""
        self.length = ""
        self.nameDescription = ""
        self.vesselID = -1
    }
    
    func printObject() {
        print("#### OBJECT: \(APIVesselDetails.entityName)")
        print("drawingURL: \(self.drawingURL)")
        print("history: \(self.history)")
        print("length: \(self.length)")
        print("nameDescription: \(self.nameDescription)")
        print("vesselID: \(self.vesselID)")
    }
}
