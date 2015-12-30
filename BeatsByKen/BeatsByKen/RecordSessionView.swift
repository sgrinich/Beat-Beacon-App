//
//  ViewController.swift
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

// Note: this file is no longer used but it's the last day of finals and I'm scared if I delete it everything will mysteriously break

import Foundation
import UIKit
import CoreData

class RecordSessionView: UIViewController {
    var participantID = 0
    var sessionID = 0
    
    @IBOutlet weak var deleteSessionButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("in record")
        println(participantID)
        println(sessionID)
        self.title = "Record Session " + String(sessionID)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem?.title = "Participant #" + String(participantID)
        //self.navigationItem.rightBarButtonItem?.
        addLeftToolbarItemOnView()
        // collection view
        
    }
    
    func addLeftToolbarItemOnView() {
        
        let button = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "onDelete")
        
        //deleteSessionButton = button
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("in prepare for segue")
        if (segue.identifier == "sessionSummarySegue") {
            println("summary segue")
            let destinationVC = segue.destinationViewController as! SessionSummaryView
            destinationVC.participantID = participantID
            destinationVC.sessionID = sessionID
        }
        
        else if (segue.identifier == "toCollectionView") {
            println("collection segue")
            let destinationVC = segue.destinationViewController as! RecordSessionCollectionView
            //destinationVC.participantID = participantID
            //destinationVC.sessionID = sessionID
        }
    }
    
    @IBAction func onDelete(sender: AnyObject) {
    }
    
    /*
    func recordTrial(sender: UIView!, trialType: String?, trialDuration : Int?, tableViewRow:Int?) {
        let recordTrialModal = storyboard?.instantiateViewControllerWithIdentifier("RecordTrialModal") as! RecordTrialView
        recordTrialModal.delegate = self;
        recordTrialModal.trialType = trialType!;
        recordTrialModal.trialDuration = trialDuration!;
        recordTrialModal.tableViewRow = tableViewRow!;
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
*/

}