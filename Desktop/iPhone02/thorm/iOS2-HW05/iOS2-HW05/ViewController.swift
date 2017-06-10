//
//  ViewController.swift
//  iOS2-HW05
//
//  Created by Mark Thorogood on 5/24/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let network = NetworkManager()
    let dataContext: NSManagedObjectContext = createMainContext()
    
    @IBAction func relationshipRecall(_ sender: UIButton) {
        let vesselFetchRequest = NSFetchRequest<Vessel>(entityName: Vessel.entityName)
        let myPredicate = NSPredicate(format: "%K == %@", #keyPath(Vessel.name), "Test")
        vesselFetchRequest.predicate = myPredicate
        
        do {
            let vessels = try dataContext.fetch(vesselFetchRequest)
            
            for v in vessels {
                try! dataContext.save()
                print("\(v.toVesselClass.name)")
            }
        } catch {
            print("Something went wrong retrieving the data: \(error)")
        }
    }
    
    @IBAction func relationshipSave(_ sender: UIButton) {
        let vessel = NSEntityDescription.insertNewObject(forEntityName: Vessel.entityName, into: dataContext) as! Vessel
        vessel.name = "Test2"
        vessel.vesselID = 5
        vessel.abbreviatedName = "AbbrevTest"
    
        let vesselClass = NSEntityDescription.insertNewObject(forEntityName: VesselClass.entityName, into: dataContext) as! VesselClass
        vesselClass.name = "VesselClass"
        vessel.toVesselClass = vesselClass
        
        do {
            try dataContext.save()
            print("Relationship saved")
        } catch {
            print("Error: \(error)")
        }
        
    
    }
    
    @IBAction func button(_ sender: UIButton) {
        let myParser = JSONParser()
        myParser.getVessels(managedObjectContext: self.dataContext)
//        for vessel in vessels {
//            print(vessel)
//        }
    }
    
    @IBAction func retrieve(_ sender: UIButton) {
        let vesselFetchRequest = NSFetchRequest<Vessel>(entityName: Vessel.entityName)
        let myPredicate = NSPredicate(format: "%K == %@", #keyPath(Vessel.name), "Cathlamet")
        vesselFetchRequest.predicate = myPredicate
        
        do {
            let vessels = try dataContext.fetch(vesselFetchRequest)
//            let vesselsExtra = vessels.dropFirst()
//            for v in vesselsExtra {
//                dataContext.delete(v)
//            }
//            try! dataContext.save()
            
            for v in vessels {
                try! dataContext.save()
                print("\(v.name + v.abbreviatedName)")
            }
        } catch {
            print("Something went wrong retrieving the data: \(error)")
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

