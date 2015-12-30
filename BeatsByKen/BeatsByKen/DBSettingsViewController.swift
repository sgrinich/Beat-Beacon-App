//
//  DBSettingsViewController.swift
//  BeatsByKen
//
//  Created by Stephen Grinich on 9/7/15.
//  Copyright (c) 2015 Liz Shank. All rights reserved.
//

import Foundation
import UIKit

class DBSettingsViewController: UIViewController{
    
    @IBOutlet weak var dbButton: UIButton!
    override func viewDidLoad() {
        
    }
    @IBAction func dbButton(sender: UIButton) {

        //DropboxSyncService.initiateAuthentication(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}