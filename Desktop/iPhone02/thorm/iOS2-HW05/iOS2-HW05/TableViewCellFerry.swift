//
//  TableViewCellFerry.swift
//  iOS2-HW05
//
//  Created by Mark Thorogood on 5/31/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit

class TableViewCellFerry: UITableViewCell {

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
