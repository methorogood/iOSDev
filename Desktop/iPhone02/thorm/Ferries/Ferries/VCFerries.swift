//
//  VCFerries.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/4/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit
import CoreData

class VCFerries: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext? = CoreDataStack.sharedInstance.persistentContainer.viewContext
    
    var fetchResultsController: NSFetchedResultsController<Vessel> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest<Vessel>(entityName: Vessel.entityName)
        let classSortDescriptor = NSSortDescriptor(key: #keyPath(Vessel.toVesselClass.name), ascending: true)
        let nameSortDescriptor = NSSortDescriptor(key: #keyPath(Vessel.name), ascending: true)
        
        fetchRequest.sortDescriptors = [classSortDescriptor, nameSortDescriptor]
        fetchRequest.fetchBatchSize = 40
        
        let aFetchedRequestController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: #keyPath(Vessel.toVesselClass.name), cacheName: nil)
        aFetchedRequestController.delegate = self
        _fetchedResultsController = aFetchedRequestController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            fatalError()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Vessel>? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

        let jParser = JSONParser()
        let cdm = CoreDataManager()
    
        jParser.getFerriesData { (apiVessels) in
            print("Number of vessels: \(apiVessels.count)")
            for v in apiVessels {
                cdm.updateOrInsertVessel(moc: CoreDataStack.sharedInstance.context, apiVessel: v)
            }
        }

        jParser.getFerriesData { (vessels) in
            // Process each vessel
            for vessel in vessels {
                jParser.getFerryDataVerbose(for: vessel.vesselID, completion: { (apiVesselDetails) in
                    cdm.updateOrInsertVesselDetails(CoreDataStack.sharedInstance.context, apiVesselDetails: apiVesselDetails)
                    print("Saved vessel details for ID: \(vessel.vesselID)")
                    //apiVesselDetails.printObject()
                })
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpView() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVCFerry" {
            let destVC = segue.destination as? VCFerry
            destVC!.data = self.vesselID
        }
    }
    var vesselID: Int16 = -1
}

extension VCFerries: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vessel = fetchResultsController.object(at: indexPath)
        vesselID = vessel.vesselID
        
        performSegue(withIdentifier: "toVCFerry", sender: self)
        
        print(vessel.name)
    }
}


extension VCFerries: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionCount = fetchResultsController.sections?.count ?? 0
        print("Number of sections in tableview: \(sectionCount)")
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultsController.sections {
            let currentSection = sections[section]
            print("Number of objects in section: \(currentSection.numberOfObjects)")
            return currentSection.numberOfObjects
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vessel = fetchResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCFerry", for: indexPath) as! TVCFerry
        configureCell(cell, withVessel: vessel)
        return cell
    }
    
    func configureCell(_ cell: TVCFerry, withVessel vessel: Vessel) {
        cell.ferryName.text = vessel.name
        if let o = vessel.toVesselDetails?.nameDescription {
            cell.ferryDescription.text = o
            if o.isEmpty {
              cell.ferryDescription.text = "No description available."
            }
        } else {
            cell.ferryDescription.text = "No description available."
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchResultsController.sections {
            let currentSection = sections[section]
            print("Current section: \(currentSection.name)")
            return "Class:  " + currentSection.name
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchResultsController.managedObjectContext
            context.delete(fetchResultsController.object(at: indexPath))

            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
}

