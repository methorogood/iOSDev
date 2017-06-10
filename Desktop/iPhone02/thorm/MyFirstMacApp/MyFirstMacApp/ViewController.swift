//
//  ViewController.swift
//  MyFirstMacApp
//
//  Created by Mark Thorogood on 5/31/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBAction func myButton(_ sender: NSButton) {
        myLabel.stringValue = "Holy Cow!!!"
    }
    
    @IBOutlet weak var myLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

