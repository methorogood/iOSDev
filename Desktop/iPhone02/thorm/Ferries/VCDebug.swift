//
//  VCDebug.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/7/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit

class VCDebug: UIViewController {

    let coreDataManager = CoreDataManager()
    let jParser = JSONParser()
    
    
    @IBAction func btnDeleteData(_ sender: UIButton) {
        coreDataManager.deleteAllVessels(moc: CoreDataStack.sharedInstance.context)
        coreDataManager.deleteAllPositionData(moc: CoreDataStack.sharedInstance.context)
        
        let alert = UIAlertController(title: "Deleted All Vessel Data", message: "Successful!", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated:  true)
    }
    
    
    @IBAction func btnDisplayMap(_ sender: UIButton) {
    }
    
    
    @IBAction func btnLoadVesselData(_ sender: UIButton) {
        loadVesselData()
        loadVesselDataVerbose()
    }
    
    func loadVesselData() {
        jParser.getFerriesData { (apiVessels) in
            print("Number of vessels: \(apiVessels.count)")
            for v in apiVessels {
                self.coreDataManager.updateOrInsertVessel(moc: CoreDataStack.sharedInstance.context, apiVessel: v)
            }
        }
    }
    
    func loadVesselDataVerbose() {
        jParser.getFerriesData { (vessels) in
            // Process each vessel
            for vessel in vessels {
                self.jParser.getFerryDataVerbose(for: vessel.vesselID, completion: { (apiVesselDetails) in
                    self.coreDataManager.updateOrInsertVesselDetails(CoreDataStack.sharedInstance.context, apiVesselDetails: apiVesselDetails)
                    print("Saved vessel details for ID: \(vessel.vesselID)")
                })
            }
        }
    }
    
    @IBAction func btnLoadPositionData(_ sender: UIButton) {
        loadPositionDataAndUpdateVessels()

        let alert = UIAlertController(title: "Loaded Position Reports", message: "Successful.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func loadPositionDataAndUpdateVessels() {
        let coreDataManager = CoreDataManager()
        let jParser = JSONParser()
        jParser.getPositionReports { (apiPositionReports) in
            for positionReport in apiPositionReports {
                positionReport.printObject()
                coreDataManager.insertPositionReport(moc: CoreDataStack.sharedInstance.context, apiPositionReport: positionReport)
                if let vessel = coreDataManager.fetchVessel(CoreDataStack.sharedInstance.context, byVesselID: positionReport.vesselID) {
                    coreDataManager.updateVesselInfo(CoreDataStack.sharedInstance.context, vessel: vessel, apiVesselPositionReport: positionReport)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDisplayMap" {
            print("Prepare for seque.")
//            loadVesselData()
//            loadVesselDataVerbose()
//            loadPositionDataAndUpdateVessels()
//            if let destSegue = segue.destination as? VCMapDebug {
//                destSegue.loadDataAndStartUpdates()
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
