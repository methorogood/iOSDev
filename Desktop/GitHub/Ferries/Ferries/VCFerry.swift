//
//  VCFerry.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/6/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit

class VCFerry: UIViewController {

    @IBOutlet weak var lblFerryName: UILabel!
    @IBOutlet weak var lblFerryDescription: UILabel!
    @IBOutlet weak var imgFerry: UIImageView!
    
    public var data: Int16 = -1
    
    // Method to download image data from a URL
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.imgFerry.image = UIImage(data: data)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cdm = CoreDataManager()
        let vessel = cdm.fetchVessel(CoreDataStack.sharedInstance.context, byVesselID: data)
        let vesselDetails = cdm.fetchVesselDetails(CoreDataStack.sharedInstance.context, byVesselID: data)
        
        lblFerryName.text = vessel?.name
        lblFerryDescription.text = vesselDetails?.nameDescription
        
        let secureURL = vesselDetails?.drawingURL.replacingOccurrences(of: "http:", with: "https:")
        
        if let checkedUrl = URL(string: (secureURL)!) {
            imgFerry.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl)
        }
   
        
        print(data)
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
