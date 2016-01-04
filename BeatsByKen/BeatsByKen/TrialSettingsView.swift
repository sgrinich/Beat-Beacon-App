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

class TrialSettingsView : UICollectionViewController, SelectDurationVCDelegate, UIPopoverPresentationControllerDelegate {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let settingsFields = ["Pre-1", "Pre-2", "Pre-3", "Pre-4", "Post-1", "Post-2", "Post-3", "Post-4", "Exer-1", "Exer-2", "Exer-3", "Exer-4"]
    let reuseIdentifier = "TrialSettingsCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 100.0, right: 20.0)

    var settings = [NSManagedObject]()
    var strSaveText : NSString!
    var duration = NSNumber()
    
    
    
    
    let defaultColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
    let highlightColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.delaysContentTouches = false;
        
        var index = Int()
        // If no trial settings have been saved, create default settings with duration of 30 seconds
        for index = 0; index<settingsFields.count; index++ {
            if (!SessionTable.checkInManagedObjectContext(managedObjectContext!, participantID: 5000, sessionID: 5000, tableViewRow: index)) {
                
                duration = 20;
                if(settingsFields[index] == "Pre-1"){
                    duration = 39;
                }
                if(settingsFields[index] == "Pre-2"){
                    duration = 32;
                }
                if(settingsFields[index] == "Pre-3"){
                    duration = 45;
                }
                if(settingsFields[index] == "Pre-4"){
                    duration = 25;
                }
                if(settingsFields[index] == "Post-1"){
                    duration = 32;
                }
                if(settingsFields[index] == "Post-2"){
                    duration = 39;
                }
                if(settingsFields[index] == "Post-3"){
                    duration = 25;
                }
                if(settingsFields[index] == "Post-4"){
                    duration = 45;
                }
                if(settingsFields[index] == "Exer-1"){
                    duration = 25;
                }
                if(settingsFields[index] == "Exer-2"){
                    duration = 45;
                }
                if(settingsFields[index] == "Exer-3"){
                    duration = 32;
                }
                if(settingsFields[index] == "Exer-4"){
                    duration = 39;
                }
                
                let newSettings = SessionTable.createTrialSettingInManagedObjectContext(managedObjectContext!, heartbeatCount: 0, trialDuration: duration, startTime: "", endTime: "", trialType: settingsFields[index], participantID: 5000, sessionID: 5000, tableViewRow: index)
                
                println(newSettings)
            }
        }
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        let darkColor = UIColor(red: 45/255, green: 61/255, blue: 77/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = darkColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        loadTrialSettings()

    }
    
  //   load the current settings into the view
    func loadTrialSettings() {
        if let temp = SessionTable.getCurrentSettings(managedObjectContext!, participantID: 5000, sessionID: 5000) {
            settings = temp
            
            print(settings)
            
            print("got some sort of settings");
        }
        else {
            println("no settings...")
        }

    }
    
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            cell.backgroundColor = highlightColor;
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            cell.backgroundColor = defaultColor;
        }
    }
    
    // on select, pop over duration pickerview
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            
            
            let setting = settings[indexPath.row]
            
            print("here?");
            
            var durationString = ""
            if let v = setting.valueForKey("trialDuration") as? Int {
                durationString = "\(v)"
            }
            
            var trialType = setting.valueForKey("trialType") as? String
            var x = "\(indexPath.row)"
            let y = x.toInt()

            selectDuration(cell, trialType: trialType, trialDuration: durationString, trialIndex: y!)
        } else {
            // Error indexPath is not on screen: this should never happen.
        }
        
    }
    


    // initialize pickerview
    func selectDuration(sender: UIView!, trialType: String?, trialDuration : String, trialIndex: Int) {
        let durationPickerView = storyboard?.instantiateViewControllerWithIdentifier("SelectDurationView") as! SelectDurationView
        
        
        durationPickerView.delegate=self;
        durationPickerView.selectedTrialType=trialType!;
        durationPickerView.selectedTrialDuration=trialDuration;
        durationPickerView.selectedTrialIndex=trialIndex;
        
        durationPickerView.modalPresentationStyle = .Popover
        if let popoverController = durationPickerView.popoverPresentationController {
            popoverController.sourceView = sender!
//            popoverController.sourceRect = sender!.bounds
            popoverController.delegate = self
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.allZeros
            popoverController.sourceRect = CGRectMake(sender.frame.width/2, sender.frame.height/2, 1, 1);
        }
        presentViewController(durationPickerView, animated: true, completion: nil)
        
    }
    
    // handle reload after duration pickerview
    func saveText(trialType: String, trialDuration: String, trialIndex: Int) {
        println()
        println("ON SAVE TEXT")
        println()
        println(trialType)
        println(trialDuration)
        let durationVal = trialDuration.toInt()
        println(durationVal! + 5)
        SessionTable.updateCurrentSetting(managedObjectContext!, heartbeatCount: 0, trialDuration: durationVal!, startTime: "", endTime: "", trialType: trialType, participantID: 5000, sessionID: 5000, tableViewRow: trialIndex)
        self.collectionView!.reloadData()
        loadTrialSettings()
        
    }
    
   //  MARK: - UIPopoverPresentationControllerDelegate
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
}

extension TrialSettingsView : UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TrialSettingsCell

        let setting = settings[indexPath.row]
        

        var str = ""
        if let v = setting.valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        
        cell.trialTypeLabel!.text = setting.valueForKey("trialType") as? String
        NSLog("Cell Text: %@", cell.trialTypeLabel!.text!);
        cell.trialDurationlabel!.text = str
        cell.layer.cornerRadius = cell.layer.frame.height/2;
        
        return cell
    }
}



extension TrialSettingsView : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 150, height: 150)
    }
    
    //3
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 80;
    }
    
    
    
}


