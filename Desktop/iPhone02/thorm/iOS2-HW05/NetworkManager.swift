//
//  NetworkManager.swift
//  iOS2-HW05
//
//  Created by Mark Thorogood on 5/24/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation

class NetworkManager {
    let defaultConfiguration = URLSessionConfiguration.default
    let ephemeralConfiguration = URLSessionConfiguration.ephemeral
    
    func doStuff3() {
        let endpoint: String = "https://www.wsdot.wa.gov/Ferries/API/Vessels/rest/vesselbasics?apiaccesscode=ef484c73-75e2-4d69-a7c2-e12abaeb3c94"
        guard let url = URL(string: endpoint) else {
            print ("Error: cannot create endpoint")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {(data, response, error) in

            guard error == nil else {
                print("Error calling api: \(error!)")
                return
            }
            
            guard let responseData = data else {
                print("Did not receive data")
                return
            }
            

            
            do {
            let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: AnyObject]]
            
                if let array = jsonResult {
                    if array.first != nil {
                        // access individual object in array
                    }
                    
                    for object in array {
                        if let vesselID = object["VesselID"] {
                        print(vesselID)
                        }
                        // access all objects in array
                    }
                    
                }
                
                
                
                
                
                //print(jsonResult)
                
                
            } catch {
                fatalError()
            }
            
            
            
            print(responseData)
        
        })
        task.resume()
        

        
    }
    
    
    
    func doStuff2() {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "https://www.wsdot.wa.gov/Ferries/API/Vessels/rest/vesselbasics?apiaccesscode=ef484c73-75e2-4d69-a7c2-e12abaeb3c94")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        
                        //Implement your logic
                        print(json)
                        
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
    }
    
    
    func doStuff() {
        let sessionWithoutDelegate = URLSession(configuration: defaultConfiguration)
    
        if let url = URL(string: "https://www.wsdot.wa.gov/ferries/api/vessels/rest/vesselbasics?apiaccesscode=2789ed78-117f-4b7e-8390-acecdd997dc3") {
            (sessionWithoutDelegate.dataTask(with: url) { (data, error, response) in
                if let error = error {
                    print("Error: \(error)")
                } else if let response = response,
                    let data = data,
                    let string = String(data: data, encoding: .utf8) {
                   
                    print(response)
                    //print(data)
                    print(string)
                    
                }
            }).resume()
        }
    }
}
