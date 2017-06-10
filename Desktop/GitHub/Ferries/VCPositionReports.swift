//
//  VCPositionReports.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/7/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit
import CoreData

class VCPositionReports: UIViewController {

    var fetchedResultsController: NSFetchedResultsController<VesselPositionReport>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let context = CoreDataStack.sharedInstance.context
        let fetchRequest = NSFetchRequest<VesselPositionReport>(entityName: VesselPositionReport.entityName)
        let sortDescriptor = NSSortDescriptor.init(key: #keyPath(VesselPositionReport.timeStamp), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self as? NSFetchedResultsControllerDelegate
        
        try! fetchedResultsController?.performFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension VCPositionReports: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController?.fetchedObjects?.count)!
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCPositionReport", for: indexPath) as! TVCPositionReport
        let pr = fetchedResultsController?.object(at: indexPath)
        cell.lblPositionReport.text = ("ID: \(pr!.vesselID) lat: \(pr!.latitude) lon: \(pr!.longitude)")
        return cell
    }

}

extension VCPositionReports: UITableViewDelegate {
    
}
