//
//  RecordTrialView.swift
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
// Counter code modified from original at:
// http://ios-blog.co.uk/tutorials/swift-nstimer-tutorial-lets-create-a-counter-application/

import Foundation
import UIKit
import CoreData

protocol RecordTrialVCDelegate
{
    func saveText()
}

class RecordTrialView: UIViewController{
    var delegate : RecordTrialVCDelegate?
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var beatsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var trialType = ""
    var trialDuration = 60
    var tableViewRow = 0
    var participantID = 0
    var sessionID = 0
    
    var heartbeatCount = 0
    var timer = NSTimer()
    var counter = 0
    var beatTimer=NSTimer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Record " + trialType + " Trial"
        self.navigationItem.hidesBackButton = true
        
        counter = trialDuration
        timerLabel.hidden = true
        
        // BEATS LABEL
        beatsLabel.hidden = true
    }
    
    //MARK -Instance Methods
    
    // update heart beat count
    func updateBeatsCount() {
        if (beatsLabel.hidden == true) {
            beatsLabel.hidden = false
        }
        beatsLabel.text = String(BTConnectorTwo.sharedBTInstance.getBeatCount())   
    }
    
    // update countdown
    func updateLabel(){
        if (counter == trialDuration) {
            startButton.hidden = true
            timerLabel.hidden = false
        }
        timerLabel.text = String(counter)
        counter -= 1
        if (counter == -1) {
            timer.invalidate()
            beatTimer.invalidate()
            
            // record final heartbeat count
            heartbeatCount = Int(BTConnectorTwo.sharedBTInstance.getBeatCount())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK -UIActions
    
    // start countdown and beats counter
    @IBAction func onStart(sender: AnyObject) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateLabel"), userInfo: nil, repeats: true)
        BTConnectorTwo.sharedBTInstance.resetBeatCount()
        beatTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "updateBeatsCount", userInfo: nil, repeats: true)
    }
    
    // create entry in managed object context and return to the recordsessionview
    @IBAction func onSave(sender: AnyObject) {
        if((self.delegate) != nil)
        {
            //delegate?.saveBeats(heartbeatCount);
            SessionTable.createInManagedObjectContext(managedObjectContext!, heartbeatCount: heartbeatCount, trialDuration: trialDuration, startTime: "" , endTime: "", trialType: trialType, participantID: participantID, sessionID: sessionID, tableViewRow: tableViewRow)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // return to the recordsessionview without modifying any core data values
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}