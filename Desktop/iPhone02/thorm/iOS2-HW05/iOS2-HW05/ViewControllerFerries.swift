//
//  ViewControllerFerries.swift
//  iOS2-HW05
//
//  Created by Mark Thorogood on 5/31/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerFerries: UIViewController, NSFetchedResultsControllerDelegate {
    
    public var context:  NSManagedObjectContext = createMainContext()

    
    var _fetchedResultsController: NSFetchedResultsController<Vessel>? = nil
    var fetchedResultsController: NSFetchedResultsController<Vessel>{
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest<Vessel>(entityName: Vessel.entityName)
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors?.append(nameSortDescriptor)
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        _fetchedResultsController = frc
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            fatalError()
        }
        return frc
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    let dataContext: NSManagedObjectContext = createMainContext()
    var vesselClasses: [VesselClass]? = nil
    var vessels: [Vessel]? = nil

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Blank out any superflouous lines.
        tableView.tableFooterView = UITableView()
        
        self.vesselClasses = getVesselClasses()
        
        self.context = createMainContext()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getVessels(forClassName: String) -> [Vessel]? {
        let vesselsFetchRequest = NSFetchRequest<Vessel>(entityName: Vessel.entityName)
        let fetchPredicate = NSPredicate(format: "%K == %@", #keyPath(Vessel.name), forClassName)
        vesselsFetchRequest.predicate = fetchPredicate
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Vessel.name), ascending: true)
        vesselsFetchRequest.sortDescriptors?.append(sortDescriptor)
        do {
            let vessels = try dataContext.fetch(vesselsFetchRequest)
            return vessels
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    func getVesselClasses() -> [VesselClass]? {
        let vesselClassesFetchRequest = NSFetchRequest<VesselClass>(entityName: VesselClass.entityName)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(VesselClass.name), ascending: true)
        vesselClassesFetchRequest.sortDescriptors?.append(sortDescriptor)
        do {
            let vesselClasses = try dataContext.fetch(vesselClassesFetchRequest)
            return vesselClasses
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
}



extension ViewControllerFerries: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let sectionInfo = fetchedResultsController.sections![section]
//        return sectionInfo.numberOfObjects
        return 3
    }
    
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return fetchedResultsController.sections?.count ?? 0
//    }  // Default is 1 unless implemented
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // Return false if you want the specified row to be editable.
    }
    
//    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let ctx = fetchedResultsController.managedObjectContext
//            ctx.delete(fetchedResultsController.object(at: indexPath))
//            
//            do {
//                try ctx.save()
//            } catch {
//                print("Error: \(error)")
//            }
//        }
//    }
    
//    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        guard let vesselClass = vesselClasses?[section] else {
//            return nil
//        }
//        
//        return vesselClass.name
//    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellFerry", for: indexPath) as! TableViewCellFerry
        
        cell.ferryName.text = "Ferry Name"

        return cell
    }
}

extension ViewControllerFerries: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let product = products[indexPath.row]
//        //  Wrap the product in an order.
//        let order = Order(product: product, qtyOrdered: 1)
//        // Add the order to the cart.
//        cart.addOrderItem(orderItem: order)
//        
//        let alert = UIAlertController(title: "Excellent Choice!!!", message: "\(product.itemName) added to your cart.", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        self.present(alert, animated:  true)
//        
//        print("Selected row at \(indexPath.row)")
    }
}
