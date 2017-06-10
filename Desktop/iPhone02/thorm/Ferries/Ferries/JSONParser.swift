//
//  JSONParser.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/5/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import CoreData

class JSONParser {
    
    // URL endpoints for service calls.
    let endpointVesselsBasic: String = "https://www.wsdot.wa.gov/Ferries/API/Vessels/rest/vesselbasics?apiaccesscode=ef484c73-75e2-4d69-a7c2-e12abaeb3c94"
    let endpointVesselLocations = "https://www.wsdot.wa.gov/Ferries/API/Vessels/rest/vessellocations?apiaccesscode=ef484c73-75e2-4d69-a7c2-e12abaeb3c94"
    let endpointVesselVerbose: String = "https://www.wsdot.wa.gov/Ferries/API/Vessels/rest/vesselverbose/{@}?apiaccesscode=ef484c73-75e2-4d69-a7c2-e12abaeb3c94"

    
    // Return the details for the specified ferry.
    func getFerryDataVerbose(for ferryID: Int16, completion: @escaping(APIVesselDetails) -> Void) {
        let defaultConfiguration = URLSessionConfiguration.default
        let sessionWithoutADelegate = URLSession(configuration: defaultConfiguration)
        let updatedString = endpointVesselVerbose.replacingOccurrences(of: "{@}", with: String(ferryID))
        
        guard let vesselVerboseURL = URL(string: updatedString) else {
            fatalError()
        }
        
        sessionWithoutADelegate.dataTask(with: vesselVerboseURL) { (data, response, error) in
            do {
                if let error = error {
                    print(error)
                } else if let data = data {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let apiVesselDetail = APIVesselDetails()
                    if let dictionary = json as? [String: Any] {
                        if let nameDesc = dictionary["VesselNameDesc"] as? String {
                            apiVesselDetail.nameDescription = nameDesc
                        }
                        if let vesselHistory = dictionary["VesselHistory"] as? String {
                            apiVesselDetail.history = vesselHistory
                        }
                        if let vesselID = dictionary["VesselID"] as? Int16 {
                            apiVesselDetail.vesselID = vesselID
                        }
                        
                        if let vesselLength = dictionary["Length"] as? String {
                            apiVesselDetail.length = vesselLength
                        }

                        if let vesselClassDictionary = dictionary["Class"] as? [String: Any] {
                            if let drawingURL = vesselClassDictionary["DrawingImg"] as? String {
                                apiVesselDetail.drawingURL = drawingURL
                            }
                        }
                        
                        DispatchQueue.main.async {
                            completion(apiVesselDetail)
                        }
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    // Return a list of ferries with basic details for each ferry.
    func getFerriesData(completion: @escaping ([APIVessel]) -> Void) {
        let defaultConfiguration = URLSessionConfiguration.default
        let sessionWithoutADelegate = URLSession(configuration: defaultConfiguration)
        
        guard let vesselBasicsURL = URL(string: endpointVesselsBasic) else {
            fatalError()
        }

        sessionWithoutADelegate.dataTask(with: vesselBasicsURL) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String:Any]]
                    
                    var vesselsResults = [APIVessel]()
                    
                    for vesselBasic in jsonResult! {
                        if let abbrevName = vesselBasic["VesselAbbrev"], let vesselName = vesselBasic["VesselName"], let vesselID = vesselBasic["VesselID"] {
                            let apiVessel = APIVessel()
                            
                            if let vesselClassDictionary = vesselBasic["Class"] as? [String: Any] {
                                if let vesselClass = vesselClassDictionary["ClassName"] as? String {
                                    apiVessel.vesselClassName = vesselClass
                                }
                            }
                    
                            apiVessel.abbrevName = abbrevName as! String
                            apiVessel.name = vesselName as! String
                            apiVessel.vesselID = vesselID as! Int16
                            
                            // Add this to the results
                            vesselsResults.append(apiVessel)
                        }
                    }
                    
                    // Return the results to the main thread.
                    DispatchQueue.main.async {
                        completion(vesselsResults)
                    }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    // Return a list of position reports.
    func getPositionReports(completion: @escaping([APIVesselPositionReport]) -> Void) {
        let defaultConfiguration = URLSessionConfiguration.default
        let sessionWithoutADelegate = URLSession(configuration: defaultConfiguration)
        
        guard let vesselLocationsURL = URL(string: endpointVesselLocations) else {
            fatalError()
        }
        
        sessionWithoutADelegate.dataTask(with: vesselLocationsURL) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String:Any]]
                    
                    var positionReports = [APIVesselPositionReport]()
                    
                    for positionReport in jsonResult! {
                        let newPostionReport = APIVesselPositionReport()
                        if let heading = positionReport["Heading"] as? Double {
                            newPostionReport.heading = heading
                        }
                        if let latitude = positionReport["Latitude"] as? Double {
                            newPostionReport.latitude = latitude
                        }
                        if let longitude = positionReport["Longitude"] as? Double {
                            newPostionReport.longitude = longitude
                        }
                        if let speed = positionReport["Speed"] as? Double {
                            newPostionReport.speed = speed
                        }
                        if let rawTimeStampAsString = positionReport["TimeStamp"] as? String {
                            newPostionReport.rawTimeStampAsString = rawTimeStampAsString
                        }
                        if let vesselID = positionReport["VesselID"] as? Int16 {
                            newPostionReport.vesselID = vesselID
                        }
                        
                        // Add the newly created position report to the array.
                        positionReports.append(newPostionReport)
                    }
                    
                    // Return the results to the main thread via a completion
                    // block handler.
                    DispatchQueue.main.async {
                        completion(positionReports)
                    }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
}

    












    
    



