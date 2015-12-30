//
//  TrialSettingsView.swift
//  BeatsByKen
//
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
// Code modified from original at:
// http://www.raywenderlich.com/78550/beginning-ios-collection-views-swift-part-1
// http://www.raywenderlich.com/78550/beginning-ios-collection-views-swift-part-2

import Foundation
import UIKit
import CoreData

class RecordSessionCollectionView : UICollectionViewController,  RecordTrialVCDelegate, UIPopoverPresentationControllerDelegate {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let settingsFields = ["Pre-1", "Pre-2", "Pre-3", "Pre-4", "Post-1", "Post-2", "Post-3", "Post-4", "Exer-1", "Exer-2", "Exer-3", "Exer-4"]
    private let reuseIdentifier = "RecordTrialCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var participantID = 0
    var sessionID = 0
    var tableViewRow = 0
    
    var settings = [NSManagedObject]()
    var strSaveText : NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for (index,field) in enumerate(settingsFields) {
            if (!SessionTable.checkInManagedObjectContext(managedObjectContext!, participantID: trialSettingsPID, sessionID: trialSettingsSID, tableViewRow: index)) {
                
                
                
                
                
                let newSettings = SessionTable.createInManagedObjectContext(managedObjectContext!, heartbeatCount: 0, trialDuration: 1, startTime: "", endTime: "", trialType: field, participantID: trialSettingsPID, sessionID: trialSettingsSID, tableViewRow: index)
                println(newSettings)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadTrialSettings()
    }
    
    // load current trial settings into the view
    /* TODO: fade out cells that already have SessionTable entries
    */
    func loadTrialSettings() {
        if let temp = SessionTable.getCurrentSettings(managedObjectContext!, participantID: trialSettingsPID, sessionID: trialSettingsSID) {
            settings = temp
        }
        else {
            println("no settings...")
        }
        
    }
    
    // on select, popover RecordTrialView
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            let setting = settings[indexPath.row]
            
            var durationInt = setting.valueForKey("trialDuration") as? Int
            
            var trialType = setting.valueForKey("trialType") as? String
            var x = "\(indexPath.row)"
            let y = x.toInt()
            
            recordTrial(cell, trialType: trialType, trialDuration: durationInt, trialIndex: y!)
        } else {
            // Error indexPath is not on screen: this should never happen.
        }
        
    }
    
    // intialize RecordTrialView
    func recordTrial(sender: UIView!, trialType: String?, trialDuration : Int?, trialIndex: Int) {
        let recordTrialModal = storyboard?.instantiateViewControllerWithIdentifier("RecordTrialModal") as! RecordTrialView
        recordTrialModal.delegate = self;
        recordTrialModal.trialType = trialType!;
        recordTrialModal.trialDuration = trialDuration!;
        recordTrialModal.tableViewRow = tableViewRow;
        recordTrialModal.participantID = participantID;
        recordTrialModal.sessionID = sessionID;
        
        recordTrialModal.modalPresentationStyle = .Popover
        if let popoverController = recordTrialModal.popoverPresentationController {
            popoverController.sourceView = sender!
            popoverController.sourceRect = sender!.bounds
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
        }
        presentViewController(recordTrialModal, animated: true, completion: nil)
    }

    // handle reload view after RecordTrialView
    func saveText() {
        self.collectionView!.reloadData()
        loadTrialSettings()
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .FullScreen
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toSessionSummary") {
            let destinationVC = segue.destinationViewController as! SessionSummaryView
            destinationVC.participantID = participantID
            destinationVC.sessionID = sessionID
        }
        
    }
}

extension RecordSessionCollectionView : UICollectionViewDataSource {
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RecordTrialCell
        
        let setting = settings[indexPath.row]
        
        var str = ""
        if let v = setting.valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        
        cell.trialTypeRLabel!.text = setting.valueForKey("trialType") as? String
        cell.trialDurationRLabel!.text = str
        
        return cell
    }
}

extension RecordSessionCollectionView : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 100, height: 200)
    }
    
    //3
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}