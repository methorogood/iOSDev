//
//  VCFerries.swift
//  iOS2-HW05
//
//  Created by Mark Thorogood on 6/4/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit

class VCFerries: UIViewController {

    
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

extension VCFerries: UITableViewDelegate {
    
}

extension VCFerries: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCFerry", for: indexPath) as! TableViewCellFerry
        
        cell.ferryName.text = "Ferry Name"
        
        return cell
    }
}
