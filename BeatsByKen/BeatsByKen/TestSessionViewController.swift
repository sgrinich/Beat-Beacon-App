//
//  MainSettingsView.swift
//  BeatsByKen
//
/*Copyright (c) 2015 Stephen Grinich

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

import Foundation
import UIKit
import CoreBluetooth
import CoreData

class TestSessionViewController: UIViewController, CSVControllerDelegate, UITextFieldDelegate{
    

    @IBOutlet weak var participantNumberTextField: UITextField!
    @IBOutlet weak var sessionNumberTextField: UITextField!
    
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var beatCountLabel: UILabel!
    @IBOutlet weak var startTrialButton: UIButton!
//    @IBOutlet weak var newSessionButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var trialStatusLabel: UILabel!
    
    @IBOutlet weak var pre1: TrialButton!
    @IBOutlet weak var pre2: TrialButton!
    @IBOutlet weak var pre3: TrialButton!
    @IBOutlet weak var pre4: TrialButton!
    
    @IBOutlet weak var post1: TrialButton!
    @IBOutlet weak var post2: TrialButton!
    @IBOutlet weak var post3: TrialButton!
    @IBOutlet weak var post4: TrialButton!
    
    @IBOutlet weak var exer1: TrialButton!
    @IBOutlet weak var exer2: TrialButton!
    @IBOutlet weak var exer3: TrialButton!
    @IBOutlet weak var exer4: TrialButton!
    
    
    
    
    var started: Bool?
    var firstTouch: Bool?
    var isTrialRunning: Bool?
    
    var trialTime: Int?
    var seconds: Int = 0;
    
    var startTime = NSTimeInterval()
    var globalTimer = NSTimer()
    var trialTimer = NSTimer()
    
    var beatDisplayTimer: NSTimer? = nil
    var bpmDisplayTimer: NSTimer? = nil
    
    var trialRunning : String = "none";
    
    var session = Session()
    
    let noTrialColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
    
//    var testTrialArray = [Session]()
    
    var duration = NSNumber()
    

    //The place where our data comes from
    var BTPeripherals = BTConnectorTwo.sharedBTInstance.getAvailablePeripherals()
    
    let dropboxSyncService = (UIApplication.sharedApplication().delegate as! AppDelegate).dropboxSyncService

    
    
    var fileName = String()
    var timeStamp = String()
    
    
    var settings = [NSManagedObject]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext


    
    func controller(controller: CSVController, didExport: Bool) {
        println("controller function in testSessionViewController called")
        session = Session();
        resetToNewSession();
        println("just called resetTonewSession in controller function")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.participantNumberTextField.delegate = self;
        self.sessionNumberTextField.delegate = self;

        
    
        self.title = "Trial";
        
        started = false;
        firstTouch = false;
        isTrialRunning = false;
//        newSessionButton.addTarget(self, action: "newSessionAction:", forControlEvents: UIControlEvents.TouchUpInside);
//        startTrialButton.setTitle("Start Trial", forState: UIControlState.Normal);
        startTrialButton.layer.cornerRadius = 15;
//        newSessionButton.layer.cornerRadius = 15;
        cancelButton.layer.cornerRadius = 15;
        
        pre1.layer.cornerRadius = pre1.layer.frame.height / 2;
        pre2.layer.cornerRadius = pre2.layer.frame.height / 2;
        pre3.layer.cornerRadius = pre3.layer.frame.height / 2;
        pre4.layer.cornerRadius = pre4.layer.frame.height / 2;
        post1.layer.cornerRadius = post1.layer.frame.height / 2;
        post2.layer.cornerRadius = post2.layer.frame.height / 2;
        post3.layer.cornerRadius = post3.layer.frame.height / 2;
        post4.layer.cornerRadius = post4.layer.frame.height / 2;
        exer1.layer.cornerRadius = exer1.layer.frame.height / 2;
        exer2.layer.cornerRadius = exer2.layer.frame.height / 2;
        exer3.layer.cornerRadius = exer3.layer.frame.height / 2;
        exer4.layer.cornerRadius = exer4.layer.frame.height / 2;
        
        doneButton.layer.cornerRadius = 15;
        
        self.beatDisplayTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector:"updateBPMLabel", userInfo: nil, repeats: true);
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        setTrialTimes();
        self.modelLabel.text = BTConnectorTwo.sharedBTInstance.getCurrentPeripheral();
        
    }
    
    func updateBeatLabel() {
        
        if(started == true){
            startTrialButton.setTitle(String(BTConnectorTwo.sharedBTInstance.getBeatCount()), forState: UIControlState.Normal);
        }
    }
    
    func newSessionAction(sender:UIButton!)
    {
        
        if(sessionIsDone(session) == false){
            displaySessionNotFinished();
        }
        
        else{
            
//            testTrialArray.append(session);
            session = Session();
            resetToNewSession();
            //session.resetAllTrials();
        }
        
        
        
    }

    @IBAction func startstopButtonTouched(sender: UIButton) {
        
        
        
        

        
        if(participantNumberTextField.text == "" || sessionNumberTextField.text == ""){
            
            if(participantNumberTextField.text == ""){
                displayNeedParticipantNumber();
            }
            
            if(sessionNumberTextField.text == ""){
                displayNeedSessionNumber();
            }
        }
            
            
        else if(BTConnectorTwo.sharedBTInstance.getCurrentPeripheral() == "None"){
            displayHRMNotConnected();
            self.modelLabel.text = BTConnectorTwo.sharedBTInstance.getCurrentPeripheral();

        }
    
        else{
        
            // we use firstTouch because we want a running counter starting at the first touch of the start button but don't want to mess with that ever again
            if(firstTouch == false){
                
                //if no trial has been selected
                if(trialRunning == "none"){
                    displayNeedTrial();
                }
                
                else{
                    
                    BTConnectorTwo.sharedBTInstance.resetBeatCount();

                    
                    trialStatusLabel.text = trialRunning + " is running.";
                    endTimeLabel.text = "N/A";

                    setTimeFromSelected();
                    
                    self.trialTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "trialTimerCount", userInfo: nil, repeats: true);
                    self.globalTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateTime", userInfo: nil, repeats: true);
                    self.startTime = NSDate.timeIntervalSinceReferenceDate();
                    firstTouch = true;
                }
            }
            
            
            if(started == false){
                
                self.trialTimer.invalidate();
                
                // if no trial has been selected
                if(trialRunning == "none"){
                    displayNeedTrial();
                }
                
                // if a trial has been selected
                else{
                    
                    BTConnectorTwo.sharedBTInstance.resetBeatCount();
                    trialStatusLabel.text = trialRunning + " is running.";
                    
                    endTimeLabel.text = "N/A";

                    
                    setTimeFromSelected();
                    
                    self.trialTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "trialTimerCount", userInfo: nil, repeats: true);
                    self.beatDisplayTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector:"updateBeatLabel", userInfo: nil, repeats: true)
                    startTimeLabel.text = stringFromTimeInterval((NSDate.timeIntervalSinceReferenceDate() - startTime)) as String;
                    started = true;
                }
            }
            
        }
    }


    func updateTime() {
        timerLabel.text = stringFromTimeInterval((NSDate.timeIntervalSinceReferenceDate() - startTime)) as String;

    }
    
    func updateBPMLabel(){
        if(BTConnectorTwo.sharedBTInstance.getBPM() == 0){
            bpmLabel.text = "Calibrating";

        }
        else{
            bpmLabel.text = String(BTConnectorTwo.sharedBTInstance.getBPM());
        }
        
        if(BTConnectorTwo.sharedBTInstance.getCurrentPeripheral() == "None"){
           // displayHRMNotConnected();
            self.modelLabel.text = BTConnectorTwo.sharedBTInstance.getCurrentPeripheral();
            
        }
    }
    
    func trialTimerCount(){
        seconds++;
        if(seconds == trialTime){
            
            endTimeLabel.text = stringFromTimeInterval((NSDate.timeIntervalSinceReferenceDate() - startTime)) as String;

            
            
            //create object here
            
            var trial = Trial();
            trial.startTime = startTimeLabel.text
            trial.endTime = endTimeLabel.text;
            trial.type = trialRunning;
            trial.beatCount = startTrialButton.titleLabel!.text;
            trial.session = sessionNumberTextField.text;
            trial.participantID = participantNumberTextField.text;
            
            setTrialForSession(trial, session: session);
            
            startTrialButton.setTitle("Start Trial", forState: UIControlState.Normal);
            started = false;
            trialStatusLabel.text = trialRunning + " is finished.";
            setFinishedTrialGray();
            setTrialAlreadyDone();

            
            BTConnectorTwo.sharedBTInstance.resetBeatCount();
            seconds = 0;
            trialTimer.invalidate();
            trialRunning = "none";
        }
        
    }
    
    func stringFromTimeInterval(interval:NSTimeInterval) -> NSString {
        
        var ti = NSInteger(interval)
        var ms = Int((interval % 1) * 100)
        var seconds = ti % 60
        var minutes = (ti / 60) % 60
        
        return NSString(format: "%0.2d:%0.2d.%0.2d",minutes,seconds,ms)
    }
    

    

    
    
    @IBAction func pre1(sender: TrialButton) {
        
        if(started ==  false){
            
            if(pre1.trialAlreadyDone == true){
                displayTrialAlreadyDone("Pre-1");
            }
            
            else{
                trialRunning = "Pre-1";
                setNonGreenColors(trialRunning);
                pre1.backgroundColor = UIColor.greenColor();

            }
        }
        
        else{
            displayTrialAlreadyRunning();

        }
    }
    
    @IBAction func pre2(sender: TrialButton) {
        
        if(started == false){
            
            if(pre2.trialAlreadyDone == true){
                displayTrialAlreadyDone("Pre-2");
            }
            else{
                trialRunning = "Pre-2";
                setNonGreenColors(trialRunning);
                pre2.backgroundColor = UIColor.greenColor();


            }
        }
        
        else{
            displayTrialAlreadyRunning();
        }
    }
    
    @IBAction func pre3(sender: TrialButton) {
        
        if(started == false){
            if(pre3.trialAlreadyDone == true){
                displayTrialAlreadyDone("Pre-3");
            }
            else{
                trialRunning = "Pre-3";
                setNonGreenColors(trialRunning);
                pre3.backgroundColor = UIColor.greenColor();


            }
        }
        
        else{
            displayTrialAlreadyRunning();
        }

    }
    
    @IBAction func pre4(sender: TrialButton) {
        
        if(started == false){
            if(pre4.trialAlreadyDone == true){
                displayTrialAlreadyDone("Pre-4");
            }
            else{
                trialRunning = "Pre-4";
                setNonGreenColors(trialRunning);
                pre4.backgroundColor = UIColor.greenColor();


            }
        }
        
        else{
            displayTrialAlreadyRunning();
        }

    }
    
    @IBAction func post1(sender: TrialButton) {
        
        if(started == false){
            if(post1.trialAlreadyDone == true){
                displayTrialAlreadyDone("Post-1");
            }
            else{
                trialRunning = "Post-1";
                setNonGreenColors(trialRunning);
                post1.backgroundColor = UIColor.greenColor();


            }
        }
        
        else{
            displayTrialAlreadyRunning();
        }


    }
    
    @IBAction func post2(sender: TrialButton) {
        
        if(started == false){
            if(post2.trialAlreadyDone == true){
                displayTrialAlreadyDone("Post-2");
            }
            else{
                trialRunning = "Post-2";
                setNonGreenColors(trialRunning);
                post2.backgroundColor = UIColor.greenColor();


            }
        }
        
        else{
            displayTrialAlreadyRunning();
        }



    }
    
    @IBAction func post3(sender: TrialButton) {
        
        if(started == false){
            if(post3.trialAlreadyDone == true){
                displayTrialAlreadyDone("Post-3");
            }
            else{
                trialRunning = "Post-3";
                setNonGreenColors(trialRunning);
                post3.backgroundColor = UIColor.greenColor();


            }
        }
        
        else{
            displayTrialAlreadyRunning();
        }
        


    }
    
    @IBAction func post4(sender: TrialButton) {
        
        if(started == false){
            if(post4.trialAlreadyDone == true){
                displayTrialAlreadyDone("Post-4");
            }
            else{
                trialRunning = "Post-4";
                setNonGreenColors(trialRunning);
                post4.backgroundColor = UIColor.greenColor();


            }
        }
        
        else{
            displayTrialAlreadyRunning();
        }



    }
    
    @IBAction func exer1(sender: TrialButton) {
        
        if(started == false){
            if(exer1.trialAlreadyDone == true){
                displayTrialAlreadyDone("Exer-1");
            }
            else{
                trialRunning = "Exer-1";
                setNonGreenColors(trialRunning);
                exer1.backgroundColor = UIColor.greenColor();


            }
        }
        
        else{
            displayTrialAlreadyRunning();
        }



    }
    
    @IBAction func exer2(sender: TrialButton) {
        
        if(started == false){
            if(exer2.trialAlreadyDone == true){
                displayTrialAlreadyDone("Exer-2");
            }
            else{
                trialRunning = "Exer-2";
                setNonGreenColors(trialRunning);
                exer2.backgroundColor = UIColor.greenColor();


            }
        }
        
        else{
            displayTrialAlreadyRunning();
        }




    }
    
    @IBAction func exer3(sender: TrialButton) {
        
        if(started == false){
            if(exer3.trialAlreadyDone == true){
                displayTrialAlreadyDone("Exer-3");
            }
            else{
                trialRunning = "Exer-3";
                setNonGreenColors(trialRunning);
                exer3.backgroundColor = UIColor.greenColor();


            }
        }
        
        else{
            displayTrialAlreadyRunning();
        }

    }
    
    @IBAction func exer4(sender: TrialButton) {
        
        if(started == false){
            if(exer4.trialAlreadyDone == true){
                displayTrialAlreadyDone("Exer-4");
            }
            else{
                trialRunning = "Exer-4";
                setNonGreenColors(trialRunning);
                exer4.backgroundColor = UIColor.greenColor();


            }
        }
        
        else{
            displayTrialAlreadyRunning();
        }

    }
    
    
    @IBAction func cancelButton(sender: UIButton) {
        
        if(started == true){
            
            trialTimer.invalidate();
            trialStatusLabel.text = trialRunning + " canceled.";
            self.startTimeLabel.text = "Canceled";
            self.endTimeLabel.text = "Canceled";
            startTrialButton.setTitle("Start Trial", forState: UIControlState.Normal);
            started = false;
            seconds = 0;
        }
        
        else{
            displayNoNeedToCancel();
            
        }
    }
    
    @IBAction func doneButton(sender: UIButton) {
        print("done button pressed");
                if(sessionIsDone(session) == false){
                    displaySessionNotFinished();
                }
                else{
                    
                    
                    if(dropboxSyncService.isLinked() == false){
                        displayDropboxProblem();
                    }
                    
                    
                    else{
                        
                        var testTrialArray = [Session]()
                        testTrialArray.append(session);

                        session = Session();
//                        resetToNewSession();

                        let csvViewController =  self.storyboard!.instantiateViewControllerWithIdentifier("CSVController") as! CSVController;
                        csvViewController.trialArray = testTrialArray;
                        
                        csvViewController.delegate = self;
                        
//                            let navController = UINavigationController(rootViewController: csvViewController) // Creating a navigation controller with resultController at the root of the navigation stack.
//                            self.presentViewController(navController, animated: true, completion: nil)
                        
                        
                        
    //                    
    //                    let date = NSDate()
    //                    let calendar = NSCalendar.currentCalendar()
    //                    let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
    //                    let dateFormatter = NSDateFormatter()
    //                    dateFormatter.dateFormat = "dd-MM-yy_hh:mm:ss"
    //                    var timeStamp = dateFormatter.stringFromDate(date);
    //
    //                    
    //                    fileName = testTrialArray[0].pre1Trial.participantID! + "." + testTrialArray[0].pre1Trial.session! + "_" + String(timeStamp) + ".csv";
    //                    
//                        self.navigationController!.pushViewController(csvViewController, animated: true)
                        

                        self.presentViewController(csvViewController, animated: true, completion: nil)
                    }
                 
                }
        
       
    }
    
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "pushCSVController"{
            let vc = segue.destinationViewController as! CSVController
            print("is this even working");
        }
    }
    
    func displayDropboxProblem(){
        let alertController = UIAlertController(title: "Wait", message:
            "Please connect to your dropbox account before going forward"+fileName, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    func displayNoNeedToCancel(){
        let alertController = UIAlertController(title: "Wait", message:
            "No trial is running. There is nothing to cancel.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    func displayNeedTrial(){
        let alertController = UIAlertController(title: "Wait", message:
            "You need to select a trial to run first. Select from Pre, Post, or Exer. ", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func displayNeedParticipantNumber(){
        let alertController = UIAlertController(title: "Wait", message:
            "Please enter a Participant Number before getting started", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displayNeedSessionNumber(){
        let alertController = UIAlertController(title: "Wait", message:
            "Please enter a Session Number before getting started", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func displaySessionNotFinished(){
        let alertController = UIAlertController(title: "Wait!", message:
            "Your session is not yet finished. Please complete all trials before moving on.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func displayHRMNotConnected(){
        let alertController = UIAlertController(title: "Wait!", message:
            "You must connect to a Heart Rate Monitoring device before testing. Please connect in Settings.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    func displayTrialAlreadyRunning(){
        let alertController = UIAlertController(title: "Wait!", message:
            "There is already a trail in progress. Please wait for it to complete before starting another.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func displayTrialAlreadyDone(trialSelected: String){
        let alertController = UIAlertController(title: "Wait!", message:
        "You've already ran this trial. Would you like to redo it?", preferredStyle: UIAlertControllerStyle.Alert)
    
        alertController.addAction(UIAlertAction(title: "Redo", style: .Default, handler: { (action: UIAlertAction!) in
            self.setRedoTrialColor(trialSelected)
            self.setRedoTrial()
        }))
    
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        
            
            println("Handle Cancel Logic here")
            
            
            
        }))
    
    
        self.presentViewController(alertController, animated: true, completion: nil)

    }

    
    func setTrialTimes()
    {
        
        
        let settingsFields = ["Pre-1", "Pre-2", "Pre-3", "Pre-4", "Post-1", "Post-2", "Post-3", "Post-4", "Exer-1", "Exer-2", "Exer-3", "Exer-4"]
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
                
            }
        }
        
        loadTrialSettings()

        var str = ""
        if let v = settings[0].valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        pre1.trialTime = str.toInt();
        
        if let v = settings[1].valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        pre2.trialTime = str.toInt();
        
        if let v = settings[2].valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        pre3.trialTime = str.toInt();
        
        if let v = settings[3].valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        pre4.trialTime = str.toInt();
        
        if let v = settings[4].valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        post1.trialTime = str.toInt();
        
        if let v = settings[5].valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        post2.trialTime = str.toInt();
        
        if let v = settings[6].valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        post3.trialTime = str.toInt();
        
        if let v = settings[7].valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        post4.trialTime = str.toInt();
        
        if let v = settings[8].valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        exer1.trialTime = str.toInt();
        
        if let v = settings[9].valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        exer2.trialTime = str.toInt();
        
        if let v = settings[10].valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        exer3.trialTime = str.toInt();
        
        if let v = settings[11].valueForKey("trialDuration") as? Int {
            str = "\(v)"
        }
        exer4.trialTime = str.toInt();
    }
    
    func loadTrialSettings() {
        if let temp = SessionTable.getCurrentSettings(managedObjectContext!, participantID: 5000, sessionID: 5000) {
            settings = temp
            
            print("got some sort of settings");
        }
        else {
            println("no settings...")
        }
        
    }
    
    func setTimeFromSelected(){
        if(trialRunning == "Pre-1"){
            trialTime = pre1.trialTime;
        }
        if(trialRunning == "Pre-2"){
            trialTime = pre2.trialTime;
        }
        if(trialRunning == "Pre-3"){
            trialTime = pre3.trialTime;
        }
        if(trialRunning == "Pre-4"){
            trialTime = pre4.trialTime;
        }
        if(trialRunning == "Post-1"){
            trialTime = post1.trialTime;
        }
        if(trialRunning == "Post-2"){
            trialTime = post2.trialTime;
        }
        if(trialRunning == "Post-3"){
            trialTime = post3.trialTime;
        }
        if(trialRunning == "Post-4"){
            trialTime = post4.trialTime;
        }
        if(trialRunning == "Exer-1"){
            trialTime = exer1.trialTime;
        }
        if(trialRunning == "Exer-2"){
            trialTime = exer2.trialTime;
        }
        if(trialRunning == "Exer-3"){
            trialTime = exer3.trialTime;
        }
        if(trialRunning == "Exer-4"){
            trialTime = exer4.trialTime;
        }
    }
    
    func setFinishedTrialGray(){
        if(trialRunning == "Pre-1"){
            pre1.backgroundColor = UIColor.darkGrayColor();
        }
        if(trialRunning == "Pre-2"){
            pre2.backgroundColor = UIColor.darkGrayColor();
        }
        if(trialRunning == "Pre-3"){
            pre3.backgroundColor = UIColor.darkGrayColor();
        }
        if(trialRunning == "Pre-4"){
            pre4.backgroundColor = UIColor.darkGrayColor();
        }
        if(trialRunning == "Post-1"){
            post1.backgroundColor = UIColor.darkGrayColor();
        }
        if(trialRunning == "Post-2"){
            post2.backgroundColor = UIColor.darkGrayColor();
        }
        if(trialRunning == "Post-3"){
            post3.backgroundColor = UIColor.darkGrayColor();
        }
        if(trialRunning == "Post-4"){
            post4.backgroundColor = UIColor.darkGrayColor();
        }
        if(trialRunning == "Exer-1"){
            exer1.backgroundColor = UIColor.darkGrayColor();
        }
        if(trialRunning == "Exer-2"){
            exer2.backgroundColor = UIColor.darkGrayColor();
        }
        if(trialRunning == "Exer-3"){
            exer3.backgroundColor = UIColor.darkGrayColor();
        }
        if(trialRunning == "Exer-4"){
            exer4.backgroundColor = UIColor.darkGrayColor();
        }
    }
    
    func setTrialAlreadyDone(){
        if(trialRunning == "Pre-1"){
            pre1.trialAlreadyDone = true;
        }
        if(trialRunning == "Pre-2"){
            pre2.trialAlreadyDone = true;
        }
        if(trialRunning == "Pre-3"){
            pre3.trialAlreadyDone = true;
        }
        if(trialRunning == "Pre-4"){
            pre4.trialAlreadyDone = true;
        }
        if(trialRunning == "Post-1"){
            post1.trialAlreadyDone = true;
        }
        if(trialRunning == "Post-2"){
            post2.trialAlreadyDone = true;
        }
        if(trialRunning == "Post-3"){
            post3.trialAlreadyDone = true;
        }
        if(trialRunning == "Post-4"){
            post4.trialAlreadyDone = true;
        }
        if(trialRunning == "Exer-1"){
            exer1.trialAlreadyDone = true;
        }
        if(trialRunning == "Exer-2"){
            exer2.trialAlreadyDone = true;
        }
        if(trialRunning == "Exer-3"){
            exer3.trialAlreadyDone = true;
        }
        if(trialRunning == "Exer-4"){
            exer4.trialAlreadyDone = true;
        }
    }
    
    func setRedoTrial(){
        
        if(trialRunning == "Pre-1"){
            pre1.redoTrial = true;
            trialRunning = "Pre-1";
            setNonGreenColors(trialRunning);
            pre1.backgroundColor = UIColor.greenColor();

        }
        if(trialRunning == "Pre-2"){
            pre2.redoTrial = true;
            trialRunning = "Pre-2";
            setNonGreenColors(trialRunning);
            pre2.backgroundColor = UIColor.greenColor();
            
        }
        if(trialRunning == "Pre-3"){
            pre3.redoTrial = true;
            trialRunning = "Pre-3";
            setNonGreenColors(trialRunning);
            pre3.backgroundColor = UIColor.greenColor();
        }
        if(trialRunning == "Pre-4"){
            pre4.redoTrial = true;
            trialRunning = "Pre-4";
            setNonGreenColors(trialRunning);
            pre4.backgroundColor = UIColor.greenColor();
        }
        if(trialRunning == "Post-1"){
            post1.redoTrial = true;
            trialRunning = "Post-1";
            setNonGreenColors(trialRunning);
            post1.backgroundColor = UIColor.greenColor();
        }
        if(trialRunning == "Post-2"){
            post2.redoTrial = true;
            trialRunning = "Post-2";
            setNonGreenColors(trialRunning);
            post2.backgroundColor = UIColor.greenColor();
        }
        if(trialRunning == "Post-3"){
            post3.redoTrial = true;
            trialRunning = "Post-3";
            setNonGreenColors(trialRunning);
            post3.backgroundColor = UIColor.greenColor();
        }
        if(trialRunning == "Post-4"){
            post4.redoTrial = true;
            trialRunning = "Post-4";
            setNonGreenColors(trialRunning);
            post4.backgroundColor = UIColor.greenColor();
        }
        if(trialRunning == "Exer-1"){
            exer1.redoTrial = true;
            trialRunning = "Exer-1";
            setNonGreenColors(trialRunning);
            exer1.backgroundColor = UIColor.greenColor();
        }
        if(trialRunning == "Exer-2"){
            exer2.redoTrial = true;
            trialRunning = "Exer-2";
            setNonGreenColors(trialRunning);
            exer2.backgroundColor = UIColor.greenColor();
        }
        if(trialRunning == "Exer-3"){
            exer3.redoTrial = true;
            trialRunning = "Exer-3";
            setNonGreenColors(trialRunning);
            exer3.backgroundColor = UIColor.greenColor();
        }
        if(trialRunning == "Exer-4"){
            exer4.redoTrial = true;
            trialRunning = "Exer-4";
            setNonGreenColors(trialRunning);
            exer4.backgroundColor = UIColor.greenColor();
        }
    }
    
    func setRedoTrialColor(trialSelected: String){
        if(trialSelected == "Pre-1"){
            setNonGreenColors(trialRunning);
            pre1.backgroundColor = UIColor.greenColor();


        }
        if(trialSelected == "Pre-2"){
            setNonGreenColors(trialRunning);
            pre2.backgroundColor = UIColor.greenColor();


        }
        if(trialSelected == "Pre-3"){
            setNonGreenColors(trialRunning);
            pre3.backgroundColor = UIColor.greenColor();


        }
        if(trialSelected == "Pre-4"){
            setNonGreenColors(trialRunning);
            pre4.backgroundColor = UIColor.greenColor();


        }
        if(trialSelected == "Post-1"){
            setNonGreenColors(trialRunning);
            post1.backgroundColor = UIColor.greenColor();


        }
        if(trialSelected == "Post-2"){
            setNonGreenColors(trialRunning);
            post2.backgroundColor = UIColor.greenColor();


        }
        if(trialSelected == "Post-3"){
            setNonGreenColors(trialRunning);
            post3.backgroundColor = UIColor.greenColor();


        }
        if(trialSelected == "Post-4"){
            setNonGreenColors(trialRunning);
            post4.backgroundColor = UIColor.greenColor();


        }
        if(trialSelected == "Exer-1"){
            setNonGreenColors(trialRunning);
            exer1.backgroundColor = UIColor.greenColor();


        }
        if(trialSelected == "Exer-2"){
            setNonGreenColors(trialRunning);
            exer2.backgroundColor = UIColor.greenColor();


        }
        if(trialSelected == "Exer-3"){
            setNonGreenColors(trialRunning);
            exer3.backgroundColor = UIColor.greenColor();


        }
        if(trialSelected == "Exer-4"){
            setNonGreenColors(trialRunning);
            exer4.backgroundColor = UIColor.greenColor();


        }
        
        trialRunning = trialSelected;
    }
    
    
    func setNonGreenColors(trialRunning: String){
        if(pre1.trialAlreadyDone == true){
            pre1.backgroundColor = UIColor.darkGrayColor();
        }
        else{
            pre1.backgroundColor = noTrialColor;
        }
            
        if(pre2.trialAlreadyDone == true){
            pre2.backgroundColor = UIColor.darkGrayColor();
        }
        else{
            pre2.backgroundColor = noTrialColor;
        }
        
        if(pre3.trialAlreadyDone == true){
            pre3.backgroundColor = UIColor.darkGrayColor();
        }
        else{
            pre3.backgroundColor = noTrialColor;
        }
        
        if(pre4.trialAlreadyDone == true){
            pre4.backgroundColor = UIColor.darkGrayColor();
        }
        else{
            pre4.backgroundColor = noTrialColor;
        }
        
        
        if(post1.trialAlreadyDone == true){
            post1.backgroundColor = UIColor.darkGrayColor();
        }
        else{
            post1.backgroundColor = noTrialColor;
        }
        
        if(post2.trialAlreadyDone == true){
            post2.backgroundColor = UIColor.darkGrayColor();
        }
        else{
            post2.backgroundColor = noTrialColor;
        }
        
        if(post3.trialAlreadyDone == true){
            post3.backgroundColor = UIColor.darkGrayColor();
        }
        else{
            post3.backgroundColor = noTrialColor;
        }
        
        if(post4.trialAlreadyDone == true){
            post4.backgroundColor = UIColor.darkGrayColor();
        }
        else{
            post4.backgroundColor = noTrialColor;
        }
        
        
        if(exer1.trialAlreadyDone == true){
            exer1.backgroundColor = UIColor.darkGrayColor();
        }
        else{
            exer1.backgroundColor = noTrialColor;
        }
        
        if(exer2.trialAlreadyDone == true){
            exer2.backgroundColor = UIColor.darkGrayColor();
        }
        else{
            exer2.backgroundColor = noTrialColor;
        }
        
        if(exer3.trialAlreadyDone == true){
            exer3.backgroundColor = UIColor.darkGrayColor();
        }
        else{
            exer3.backgroundColor = noTrialColor;
        }
        
        if(exer4.trialAlreadyDone == true){
            exer4.backgroundColor = UIColor.darkGrayColor();
        }
        else{
            exer4.backgroundColor = noTrialColor;
        }
        
        
    }
    
    func setTrialForSession(trial: Trial, session: Session){
        
        if(trial.type == "Pre-1"){
            session.pre1Trial = trial;
        }
        if(trial.type == "Pre-2"){
            session.pre2Trial = trial;
        }
        if(trial.type == "Pre-3"){
            session.pre3Trial = trial;
        }
        if(trial.type == "Pre-4"){
            session.pre4Trial = trial;
        }
        if(trial.type == "Post-1"){
            session.post1Trial = trial;
        }
        if(trial.type == "Post-2"){
            session.post2Trial = trial;
        }
        if(trial.type == "Post-3"){
            session.post3Trial = trial;
        }
        if(trial.type == "Post-4"){
            session.post4Trial = trial;
        }
        if(trial.type == "Exer-1"){
            session.exer1Trial = trial;
        }
        if(trial.type == "Exer-2"){
            session.exer2Trial = trial;
        }
        if(trial.type == "Exer-3"){
            session.exer3Trial = trial;
        }
        if(trial.type == "Exer-4"){
            session.exer4Trial = trial;
        }
        
    }
    
    func sessionIsDone(session: Session) -> Bool{
        if(session.pre1Trial.endTime == nil){
            return false;
        }
        if(session.pre2Trial.endTime == nil){
            return false;
        }
        if(session.pre3Trial.endTime == nil){
            return false;
        }
        if(session.pre4Trial.endTime == nil){
            return false;
        }
        if(session.post1Trial.endTime == nil){
            return false;
        }
        if(session.post2Trial.endTime == nil){
            return false;
        }
        if(session.post3Trial.endTime == nil){
            return false;
        }
        if(session.post4Trial.endTime == nil){
            return false;
        }
        if(session.exer1Trial.endTime == nil){
            return false;
        }
        if(session.exer2Trial.endTime == nil){
            return false;
        }
        if(session.exer3Trial.endTime == nil){
            return false;
        }
        if(session.exer4Trial.endTime == nil){
            return false;
        }
        
        return true;
    }
    
    func resetToNewSession(){
        println("resetting to a new session")
//        var testTrialArray = [Session]() // this makes it so we never have more than one instance of each pre, post, exer. Was confused about this earlier. If we want multiple session in the csv
        // at the end, erase this line
        self.globalTimer.invalidate();
        timerLabel.text = "00:00.00";
        sessionNumberTextField.text = "";
        firstTouch = false;
        trialRunning = "none";
        firstTouch = false;
        pre1.backgroundColor = noTrialColor;
        pre2.backgroundColor = noTrialColor;
        pre3.backgroundColor = noTrialColor;
        pre4.backgroundColor = noTrialColor;
        post1.backgroundColor = noTrialColor;
        post2.backgroundColor = noTrialColor;
        post3.backgroundColor = noTrialColor;
        post4.backgroundColor = noTrialColor;
        exer1.backgroundColor = noTrialColor;
        exer2.backgroundColor = noTrialColor;
        exer3.backgroundColor = noTrialColor;
        exer4.backgroundColor = noTrialColor;
        
        pre1.trialAlreadyDone = false;
        pre2.trialAlreadyDone = false;
        pre3.trialAlreadyDone = false;
        pre4.trialAlreadyDone = false;
        post1.trialAlreadyDone = false;
        post2.trialAlreadyDone = false;
        post3.trialAlreadyDone = false;
        post4.trialAlreadyDone = false;
        exer1.trialAlreadyDone = false;
        exer2.trialAlreadyDone = false;
        exer3.trialAlreadyDone = false;
        exer4.trialAlreadyDone = false;
        
        pre1.redoTrial = false;
        pre2.redoTrial = false;
        pre3.redoTrial = false;
        pre4.redoTrial = false;
        post1.redoTrial = false;
        post2.redoTrial = false;
        post3.redoTrial = false;
        post4.redoTrial = false;
        exer1.redoTrial = false;
        exer2.redoTrial = false;
        exer3.redoTrial = false;
        exer4.redoTrial = false;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}