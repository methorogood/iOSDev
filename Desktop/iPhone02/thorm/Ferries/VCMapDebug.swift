//
//  VCMapDebug.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/7/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class VCMapDebug: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    var annotations:[Int16:MapVesselAnnotation] = [:]
    let coreDataManager = CoreDataManager()
    var fetchedResultsController: NSFetchedResultsController<Vessel>?
    let jParser = JSONParser()
    var moc: NSManagedObjectContext? = CoreDataStack.sharedInstance.context
    var timer: Timer?
    var userPreferences: UserPreferences = UserPreferences()
    
    
    func beginContinuousUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true, block: { (timer) in
            self.coreDataManager.updateVesselPositionReports(jParser: self.jParser)
            self.updateVesselAnnotationsOnMap()
        })
    }
    
    
    func endContinuousUpdates() {
        timer?.invalidate()
        timer = nil
    }
    
    
    func updateVesselAnnotationsOnMap() {
        if let vessels = fetchedResultsController?.fetchedObjects {
            for vessel in vessels {
                if let ann = annotations[vessel.vesselID] {
                    ann.coordinate.latitude = vessel.lastLatitude
                    ann.coordinate.longitude = vessel.lastLongitude
                } else {
                    //let annotations[vessel.ID]
                    let annotation = MapVesselAnnotation.annotation(vessel: vessel)
                    annotations[vessel.vesselID] = annotation
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    
    public func loadFetchResultsController() {
        // Fetch vessels into the Fetch Results Controller.
        let fetchRequest = NSFetchRequest<Vessel>(entityName: Vessel.entityName)
        let sortDescriptor = NSSortDescriptor.init(key: #keyPath(Vessel.name), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Error loading vessels: \(error)")
        }
        
        updateVesselAnnotationsOnMap()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the map view based on user preferences.
        let latitudeCenter = userPreferences.latitudeCenter
        let latitudeDelta = userPreferences.latitudeDelta
        let longitudeCenter = userPreferences.longitudeCenter
        let longitudeDelta = userPreferences.longitudeDelta
        let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: latitudeCenter, longitude: longitudeCenter), span)

        mapView.isRotateEnabled = false
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        
        loadFetchResultsController()
        beginContinuousUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        endContinuousUpdates()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VCMapDebug: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Update user preferences based on the new map region display.
        userPreferences.latitudeCenter = mapView.region.center.latitude
        userPreferences.latitudeDelta = mapView.region.span.latitudeDelta
        userPreferences.longitudeCenter = mapView.region.center.longitude
        userPreferences.longitudeDelta = mapView.region.span.longitudeDelta
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "annotationReuseId"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "ferry.png")
        
        return annotationView
    }
    
}
