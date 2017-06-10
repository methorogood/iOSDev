//
//  JSONParser.swift
//  iOS2-HW05
//
//  Created by Mark Thorogood on 5/25/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import CoreData

class JSONParser {
    
    let endpointVessels: String = "https://www.wsdot.wa.gov/Ferries/API/Vessels/rest/vesselbasics?apiaccesscode=ef484c73-75e2-4d69-a7c2-e12abaeb3c94"

    func getVessels(managedObjectContext: NSManagedObjectContext) {
        //var results = [Vessel]()
        
        guard let url = URL(string: endpointVessels) else {
            print ("Error: cannot create endpoint for getVessels().")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
            guard error == nil else {
                print("Error calling api: \(error!)")
                return
            }
            guard let responseData = data else {
                print("Did not receive data from: \(self.endpointVessels)")
                return
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: AnyObject]]
                
                if let array = jsonResult {
                    for object in array {
                        let vessel = NSEntityDescription.insertNewObject(forEntityName: Vessel.entityName, into: managedObjectContext) as! Vessel
                        
                        if let vesselID = object["VesselID"] as? Int16 {
                            print("Vessel ID: \(vesselID)")
                            vessel.vesselID = vesselID
                        }
                        if let vesselName = object["VesselName"] as? String {
                            //newVessel.name = vesselName
                            print("Vessel Name: \(vesselName)")
                            vessel.name = vesselName
                        }
                        if let vesselAbbrev = object["VesselAbbrev"] as? String {
                            //newVessel.abbrevName = vesselAbbrev
                            print("Vessel abbreviation: \(vesselAbbrev)")
                            vessel.abbreviatedName = vesselAbbrev
                        }
                        
                        do {
                            try managedObjectContext.save()
                        } catch {
                            print("Error inserting vessel: \(error)")
                            managedObjectContext.rollback()
                        }
                    }
                }
            } catch {
                fatalError()
            }
        })
        task.resume()
    }
    
}
