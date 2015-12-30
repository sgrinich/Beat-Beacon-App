//
//  ViewController.swift
//  BeatsByKen
/*Copyright (c) 2015 Aidan Carroll, Alex Calamaro, Max Willard, Liz Shank

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/


// note: this file is no longer used
import UIKit
import Foundation
import CoreData

class Home: UIViewController {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

        //println(managedObjectContext)
        /*
        let newItem = SessionTable.createInManagedObjectContext(managedObjectContext!, heartbeatCount: 4, trialDuration: 5, trialType: "pre1", participantID: 4, sessionID: 1,tableViewRow: 0)
        
        let settingsFields = ["Pre-1", "Pre-2", "Pre-3", "Pre-4", "Post-1", "Post-2", "Post-3", "Post-4", "Exer-1", "Exer-2", "Exer-3", "Exer-4"]
        
        
        for (index,field) in enumerate(settingsFields) {
            if (!SessionTable.checkInManagedObjectContext(managedObjectContext!, participantID: trialSettingsPID, sessionID: trialSettingsSID, tableViewRow: index)) {
                let newSettings = SessionTable.createInManagedObjectContext(managedObjectContext!, heartbeatCount: 0, trialDuration: 30, trialType: field, participantID: trialSettingsPID, sessionID: trialSettingsSID, tableViewRow: index)
                println(newSettings)
            }
        }
        
        if let x = SessionTable.getCurrentSettings(managedObjectContext!, participantID: trialSettingsPID, sessionID: trialSettingsSID) {
            println("HOME")
            println(x)
        }
        */
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}