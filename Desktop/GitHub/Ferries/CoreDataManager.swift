//
//  CoreDataManager.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/6/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    func deleteAllPositionData(moc: NSManagedObjectContext) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: VesselPositionReport.entityName))
        do {
            try moc.execute(batchDeleteRequest)
        } catch {
            print("Error deleting Position Reports: \(error)")
        }
    }
    
    
    func deleteAllVessels(moc: NSManagedObjectContext) {
        let deleteAllObjects = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: Vessel.entityName))
        do {
            try moc.execute(deleteAllObjects)
        }
        catch {
            print("Error deleting all Vessel data: \(error)")
            fatalError()
        }
    }
    
    func fetchVessel(_ moc: NSManagedObjectContext, byVesselID: Int16) -> Vessel? {
        let vesselFetchRequest = NSFetchRequest<Vessel>(entityName: Vessel.entityName)
        let fetchPredicate = NSPredicate(format: "%K == %@", #keyPath(Vessel.vesselID), NSNumber(integerLiteral: Int(byVesselID)))
        vesselFetchRequest.predicate = fetchPredicate
        
        do {
            let vessels = try CoreDataStack.sharedInstance.context.fetch(vesselFetchRequest)
            if vessels.count > 0 {
                return vessels[0]
            } else {
                return nil
            }
        } catch {
            print("Error fetching : \(error)")
            fatalError()
        }
    }
    
    
    func fetchVesselClass(_ moc: NSManagedObjectContext, byVesselClassName: String) -> VesselClass? {
        let vesselClassFetchRequest = NSFetchRequest<VesselClass>(entityName: VesselClass.entityName)
        let fetchPredicate = NSPredicate(format: "%K == %@", #keyPath(VesselClass.name), byVesselClassName)
        vesselClassFetchRequest.predicate = fetchPredicate
        
        do {
            let vesselClasses = try moc.fetch(vesselClassFetchRequest)
            if vesselClasses.count > 0 {
                return vesselClasses[0]
            } else {
                let newVesselClass = NSEntityDescription.insertNewObject(forEntityName: VesselClass.entityName, into: moc) as! VesselClass
                newVesselClass.name = byVesselClassName
                do {
                    try CoreDataStack.sharedInstance.context.save()
                    return newVesselClass
                } catch {
                    print("Error inserting new Vessel Class: \(error)")
                    fatalError()
                }
            }
        } catch {
            print("Error fetching : \(error)")
            fatalError()
        }
    }
    
    
    func fetchVesselDetails(_ moc: NSManagedObjectContext, byVesselID: Int16) -> VesselDetails? {
        let fetchRequest = NSFetchRequest<VesselDetails>(entityName: VesselDetails.entityName)
        let fetchPredicate = NSPredicate(format: "%K == %@", #keyPath(VesselDetails.vesselID), NSNumber(integerLiteral: Int(byVesselID)))
        fetchRequest.predicate = fetchPredicate
        
        do {
            let fetchResults = try moc.fetch(fetchRequest)
            if fetchResults.count > 0 {
                return fetchResults[0]
            } else {
                return nil
            }
        } catch {
            print ("Error fetching Vessel Details for vesselID: \(byVesselID)")
        }
        return nil
    }
    

    func insertPositionReport(moc: NSManagedObjectContext, apiPositionReport: APIVesselPositionReport) -> Void {
        
        if let vessel = fetchVessel(moc, byVesselID: apiPositionReport.vesselID) {
            let positionReport = NSEntityDescription.insertNewObject(forEntityName: VesselPositionReport.entityName, into: moc) as! VesselPositionReport
            positionReport.heading = apiPositionReport.heading
            positionReport.latitude = apiPositionReport.latitude
            positionReport.longitude = apiPositionReport.longitude
            positionReport.speed = apiPositionReport.speed
            positionReport.timeStamp = apiPositionReport.timeStamp
            positionReport.vesselID = apiPositionReport.vesselID
            
            // Save the relationship information.
            positionReport.toVessel = vessel
            
            do {
                try moc.save()
            } catch {
                moc.rollback()
                print("Error saving Position Report to database: \(error)")
            }
            
        } else {
            print("Warning:  Vessel ID not found for position report.  Report not saved to the database.")
        }
    }
    
    
    // Performs all the functions needed to update or insert into Core Data.
    func updateOrInsertVessel(moc: NSManagedObjectContext, apiVessel: APIVessel) -> Void {

        var vesselClass: VesselClass? = nil
        
        if !(apiVessel.vesselClassName.isEmpty) {
            vesselClass = fetchVesselClass(moc, byVesselClassName: apiVessel.vesselClassName)
        }
        
        if let vessel = fetchVessel(moc, byVesselID: apiVessel.vesselID) {
            // Update vessel
            vessel.abbrevName = apiVessel.abbrevName
            vessel.name = apiVessel.name
            
            vessel.toVesselClass = vesselClass
            
            do {
                try moc.save()
            } catch {
                print("Error saving updates to vessel: \(error)")
            }
        } else {
            // Insert vessel
            let newVessel = NSEntityDescription.insertNewObject(forEntityName: Vessel.entityName, into: moc) as! Vessel
            newVessel.abbrevName = apiVessel.abbrevName
            newVessel.name = apiVessel.name
            newVessel.vesselID = apiVessel.vesselID

            newVessel.toVesselClass = vesselClass
            
            do {
                print("Inserting vessel info for \(apiVessel.vesselID)")
                try moc.save()
            } catch {
                print("Error saving inserted vessel: \(error)")
            }
        }
        print("updateOrInsert completed for: \(apiVessel.vesselID)")
    }
    
    
    func updateOrInsertVesselDetails(_ moc: NSManagedObjectContext, apiVesselDetails: APIVesselDetails) {
        
        if let vesselDetails = fetchVesselDetails(moc, byVesselID: apiVesselDetails.vesselID) {
            vesselDetails.drawingURL = apiVesselDetails.drawingURL
            vesselDetails.history = apiVesselDetails.history
            vesselDetails.length = apiVesselDetails.length
            vesselDetails.nameDescription = apiVesselDetails.nameDescription
            
            if let associatedVessel = fetchVessel(moc, byVesselID: apiVesselDetails.vesselID) {
                vesselDetails.toVessel = associatedVessel
                associatedVessel.toVesselDetails = vesselDetails
            }
            
            do {
                try moc.save()
            } catch {
                print("Error updating Vessel Details for VesselID: \(apiVesselDetails.vesselID)")
                moc.rollback()
            }
        } else {
            let newVesselDetails = NSEntityDescription.insertNewObject(forEntityName: VesselDetails.entityName, into: moc) as! VesselDetails
            newVesselDetails.vesselID = apiVesselDetails.vesselID
            newVesselDetails.drawingURL = apiVesselDetails.drawingURL
            newVesselDetails.history = apiVesselDetails.history
            newVesselDetails.length = apiVesselDetails.length
            newVesselDetails.nameDescription = apiVesselDetails.nameDescription
            
            if let associatedVessel = fetchVessel(moc, byVesselID: apiVesselDetails.vesselID) {
                newVesselDetails.toVessel = associatedVessel
                associatedVessel.toVesselDetails = newVesselDetails
            }
            
            do {
                try moc.save()
            } catch {
                print("Error inserting new Vessel Details")
                moc.rollback()
            }
        }
    }

    
    // Updates all position reports from JSON service.
    func updateVesselPositionReports(jParser: JSONParser) {
        jParser.getPositionReports { (positionReports) in
            for positionReport in positionReports {
                positionReport.printObject()
                self.insertPositionReport(moc: CoreDataStack.sharedInstance.context, apiPositionReport: positionReport)
                if let vessel = self.fetchVessel(CoreDataStack.sharedInstance.context, byVesselID: positionReport.vesselID) {
                    self.updateVesselInfo(CoreDataStack.sharedInstance.context, vessel: vessel, apiVesselPositionReport: positionReport)
                }
            }
        }
    }
    
    
    func updateVesselInfo(_ moc: NSManagedObjectContext, vessel: Vessel, apiVesselPositionReport: APIVesselPositionReport) {
        guard let lastPositionUpdate = apiVesselPositionReport.timeStamp else {
            print("Warning: apiVesselPositionReport.timpStamp is nil for vesselID: \(vessel.vesselID)")
            return
        }
        
        vessel.lastLatitude = apiVesselPositionReport.latitude
        vessel.lastLongitude = apiVesselPositionReport.longitude
        vessel.lastPositionUpdateTime = lastPositionUpdate
        
        do {
            try moc.save()
        } catch {
            print("Error attempting to update vessel with position report information: \(error)")
            moc.rollback()
        }
    }

    
}
