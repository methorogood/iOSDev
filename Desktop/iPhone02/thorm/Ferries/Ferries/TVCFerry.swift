//
//  TVCFerry.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/4/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit

class TVCFerry: UITableViewCell {
    
    @IBOutlet weak var ferryDescription: UILabel!

    @IBOutlet weak var ferryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
