//
//  CSVController.swift
//  BeatsByKen
//
//  Created by Stephen Grinich on 9/6/15.
//  Copyright (c) 2015 Liz Shank. All rights reserved.
//

import Foundation
import CoreData

protocol CSVControllerDelegate {
    func controller(controller: CSVController, didExport: Bool)
}

class CSVController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    var delegate: CSVControllerDelegate! = nil
    
    var trialArray = [Session]()
    var fileName = String()
    
    var arrayForPopulation = [Trial]()
    var csv = String()
    
    var trialType = ""
    var trialDuration = 60
    var tableViewRow = NSNumber()
    var participantID = NSNumber()
    var startTime = String()
    var endTime = String()
    var sessionID = NSNumber()
    var heartbeatCount = NSNumber()

    let dropboxSyncService = (UIApplication.sharedApplication().delegate as! AppDelegate).dropboxSyncService
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext


    var session = [NSManagedObject]()

    
    let cellBackgroundColor = UIColor(red: 51/255, green: 153/255, blue: 204/255, alpha: 1)

    @IBOutlet weak var redBarLeftmostItem: UILabel!
    @IBOutlet weak var redBarRightmostItem: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    var tableView: UITableView = UITableView()
    

    @IBOutlet weak var backButton: UIButton!
   // @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!
    

    
    override func viewDidLoad() {
        
        fromSessionToCells();
        
        tableView.frame         =   CGRectMake(redBarLeftmostItem.frame.origin.x, redBarLeftmostItem.frame.origin.y + redBarLeftmostItem.frame.height, redBarRightmostItem.frame.origin.x + redBarRightmostItem.frame.width-20, exportButton.frame.origin.y - 100);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.registerClass(CSVTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
        self.backButton.layer.cornerRadius = 25;
        self.exportButton.layer.cornerRadius = 25;
     //   self.saveButton.layer.cornerRadius = 25;
        
        //back button stuff
//        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
//        navigationItem.leftBarButtonItem = backButton
    
       
        
        
    }
    
    func goBack(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fromSessionToCells(){
        
        for var j=0; j<trialArray.count; j++
        {
            arrayForPopulation.append(trialArray[j].pre1Trial);
            arrayForPopulation.append(trialArray[j].pre2Trial);
            arrayForPopulation.append(trialArray[j].pre3Trial);
            arrayForPopulation.append(trialArray[j].pre4Trial);
            arrayForPopulation.append(trialArray[j].post1Trial);
            arrayForPopulation.append(trialArray[j].post2Trial);
            arrayForPopulation.append(trialArray[j].post3Trial);
            arrayForPopulation.append(trialArray[j].post4Trial);
            arrayForPopulation.append(trialArray[j].exer1Trial);
            arrayForPopulation.append(trialArray[j].exer2Trial);
            arrayForPopulation.append(trialArray[j].exer3Trial);
            arrayForPopulation.append(trialArray[j].exer4Trial);
        }
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayForPopulation.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell:CSVTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! CSVTableViewCell
        
            cell.participantIDLabel.text = arrayForPopulation[indexPath.row].participantID;
            cell.sessionLabel.text = arrayForPopulation[indexPath.row].session;
            cell.trialLabel.text = arrayForPopulation[indexPath.row].type;
            cell.startTimeLabel.text=arrayForPopulation[indexPath.row].startTime;
            cell.endTimeLabel.text=arrayForPopulation[indexPath.row].endTime;
            cell.beatCountLabel.text=arrayForPopulation[indexPath.row].beatCount;
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    
 
    @IBAction func backButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    
    @IBAction func saveButton(sender: UIButton) {
        
        // loop through all trials in all sesssions
        for var j=0; j<arrayForPopulation.count; j++
        {
            
            heartbeatCount = NSNumber(integer: arrayForPopulation[j].beatCount!.toInt()!);
            trialDuration = 0;
            startTime = arrayForPopulation[j].startTime!;
            endTime = arrayForPopulation[j].endTime!;
            participantID = NSNumber(integer: arrayForPopulation[j].participantID!.toInt()!);
            sessionID = NSNumber(integer: arrayForPopulation[j].session!.toInt()!);
            tableViewRow = NSNumber(integer: j);
            trialType = arrayForPopulation[j].type!;
            
            
            let sesssion = SessionTable.createInManagedObjectContext(managedObjectContext!, heartbeatCount: heartbeatCount, trialDuration: trialDuration, startTime: startTime, endTime: endTime, trialType: trialType, participantID: participantID, sessionID: sessionID, tableViewRow: tableViewRow);
//            
//            print(trialType)
//            print(startTime)
//            print(endTime)
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    
    }
    
    @IBAction func exportButton(sender: UIButton) {
        
        
        
        var dropboxConfirm = UIAlertController(title: "Export to Dropbox?", message: "Confirm you would like to export file to linked Dropbox account.", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        dropboxConfirm.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
            self.csv = "Participant #, Session, Trial, Start Time, Stop Time, Heartbeat Count";
            
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yy_hh:mm:ssa"
            var timeStamp = dateFormatter.stringFromDate(date);
            self.fileName = self.trialArray[0].pre1Trial.participantID! + "." + self.trialArray[0].pre1Trial.session! + "_" + String(timeStamp) + ".csv";
            
            
            for var j=0; j<self.arrayForPopulation.count; j++
            {
                self.csv += "\n" + self.arrayForPopulation[j].participantID! + "," + self.arrayForPopulation[j].session! + "," + self.arrayForPopulation[j].type! + "," + self.arrayForPopulation[j].startTime! + "," + self.arrayForPopulation[j].endTime! + "," + self.arrayForPopulation[j].beatCount!;
            }
            
            let csvData = (self.csv as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            
            
            if(self.dropboxSyncService.isLinked() == false){
                print("Account is not linked!!!")
           self.displayDropboxProblem()
                
            }
                
            else{
                
                if let finalData = csvData{
                    self.dropboxSyncService.saveFile(self.fileName, data: finalData);
                    
                    self.delegate!.controller(self, didExport: true)
                    println("in csvController calling self.delegate!")
                    
                    
                    self.displayAddedToDropbox();
                    
                    
                    
                    print("made it here");
                }
                    
                else{
                    self.displayDropboxProblem()
                    print("problem with werid swift thing");
                }
                
            }
            
//            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        dropboxConfirm.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            
            dropboxConfirm.dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        presentViewController(dropboxConfirm, animated: true, completion: nil)

        
        

  
    }
    
    func displayAddedToDropbox(){
        
        
        var addedAlert = UIAlertController(title: "Exported", message: "Successfully saved to your Dropbox as:  "+fileName, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        addedAlert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action: UIAlertAction!) in
//            addedAlert.dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
//        
//        let alertController = UIAlertController(title: "Nice", message:
//            "Check your Dropbox folder for: "+fileName, preferredStyle: UIAlertControllerStyle.Alert)
//        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(addedAlert, animated: true, completion: nil)
//        addedAlert.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func displayDropboxProblem(){
        let alertController = UIAlertController(title: "Wait", message:
            "There was a problem uploading to Dropbox. Troubleshoot by either: reconnecting to your Dropbox account or force quitting this app."+fileName, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    
    
}