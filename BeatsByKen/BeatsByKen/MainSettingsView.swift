//
//  MainSettingsView.swift
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

import Foundation
import UIKit
import CoreBluetooth

class MainSettingsView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
//    @IBOutlet weak var trialButton: UIButton!
    @IBOutlet weak var dbButton: UIButton!
//    @IBOutlet weak var runTrialsButton: UIButton!
    
    
    
    
    let dropboxSyncService = (UIApplication.sharedApplication().delegate as! AppDelegate).dropboxSyncService

    
    
    

    
    
    
    // The table view which stores available BLE heart rate monitors
    @IBOutlet var BTTableView: UITableView!
    
    //Disconnect button which must be shown contextually
    @IBOutlet var DisconnectButton: UIButton!
    
    //Make the disconnect button disconnect
    @IBAction func DisconnectButtonPress(sender: AnyObject) {
        
        
        var refreshAlert = UIAlertController(title: "Disconnect?", message: "You will be disconnected from this Heart Rate Monitor", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            BTConnectorTwo.sharedBTInstance.disconnect()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            println("Not disconnected")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    //Set up auto-scan switch
    @IBOutlet var AutoScanSwitch: UISwitch!

    //Name of Connected Device
    @IBOutlet var ConnectedDeviceDisplayName: UILabel!
    
    //The place where our data comes from
    var BTPeripherals = BTConnectorTwo.sharedBTInstance.getAvailablePeripherals()
    
    //The text cell identifier for ease of reuse
    let textCellIdentifier = "BTTextCell"
    
    //Timer to keep peripherals up to date
    var timer:NSTimer?
    
    //Set up refresh pull-down to request a scan from BTConnectorTwo
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "requestScanForNewPeripherals", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbButton.layer.cornerRadius = 15;
//        runTrialsButton.layer.cornerRadius = 15;
        DisconnectButton.layer.cornerRadius = 15;
        
        if(dropboxSyncService.isLinked() == true){
            dbButton.setTitle("Disconnect Dropbox", forState: UIControlState.Normal);
        }
        
 
        
//        dbButton.layer.cornerRadius = 15;
//        trialButton.layer.cornerRadius = 15;
//        DisconnectButton.layer.cornerRadius = 15;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDidLinkNotification:", name: "didLinkToDropboxAccountNotification", object: nil)
        
        
        //Set up datasource and delegate
        BTTableView.delegate = self
        BTTableView.dataSource = self
        
        //Set up timer for updating TableView
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "refreshBTTable", userInfo: nil, repeats: true)
    
        
        //Set currently connected display
        ConnectedDeviceDisplayName.text = BTConnectorTwo.sharedBTInstance.getCurrentPeripheral()
        
        //Set up button
        refreshDisconnectButton()
        
        //More refresh setup
        self.BTTableView.addSubview(self.refreshControl)
        
        //Set enable auto-scan switch actions
        AutoScanSwitch.addTarget(self, action: Selector("autoScanStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)

    }
    
    //Refresh the things
    func refreshBTTable(){
        BTPeripherals = BTConnectorTwo.sharedBTInstance.getAvailablePeripherals()
        ConnectedDeviceDisplayName.text = BTConnectorTwo.sharedBTInstance.getCurrentPeripheral()
        refreshDisconnectButton()
        BTTableView.reloadData()
    }
    //Manual refrsh scan
    func requestScanForNewPeripherals(){
        BTConnectorTwo.sharedBTInstance.refreshPeripherals()
        var scanTime = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "finishManualScanRefresh", userInfo: nil, repeats: false)
        BTTableView.reloadData()
        refreshControl.endRefreshing()
    }
    //Ending the manual scan so as not to waste battery
    func finishManualScanRefresh(){
        BTConnectorTwo.sharedBTInstance.stopScanning()
        BTPeripherals = BTConnectorTwo.sharedBTInstance.getAvailablePeripherals()
        refreshBTTable()
        BTTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    //Kind of hard coded
    func refreshDisconnectButton(){
        if BTConnectorTwo.sharedBTInstance.getCurrentPeripheral() == "None"{
            DisconnectButton.hidden = true
        }else{
            DisconnectButton.hidden = false
        }
    }
    
    //Handle autoscan switch state changes
    func autoScanStateChanged(switchState: UISwitch){
        if switchState.on{
            //Disable autoscan
            BTConnectorTwo.sharedBTInstance.disableAutomaticScan()
        }else{
            //enable autoscan
            BTConnectorTwo.sharedBTInstance.enableAutomaticScan()
        }
    }
    
    //Onclick make call to BTConnectorTwo to connect to a device
    func tableView(BTTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        //Only allow connection to new device if no device is currently paired
        if BTConnectorTwo.sharedBTInstance.getCurrentPeripheral() == "None"{
            var peripheral = BTPeripherals[indexPath.row] as CBPeripheral
            BTConnectorTwo.sharedBTInstance.setAndConnectPeripheral(peripheral)
        }
    }
    
    func numberOfSectionsInTableView(BTTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(BTTableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return BTPeripherals.count
    }
    
    func tableView(BTTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = BTTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = BTPeripherals[row].name
        
        return cell
    }
    
    @IBAction func dbButton(sender: UIButton) {
        
        if(dropboxSyncService.isLinked() == false){
          //  dbButton.setTitle("Link Dropbox Account", forState: UIControlState.Normal);
            dropboxSyncService.initiateAuthentication(self)
        }
        else{
            dropboxSyncService.unlinkAll()
             dbButton.setTitle("Connect to Dropbox", forState: UIControlState.Normal)

            
        }
    }
    
    
    
    
    
    
    
    func handleDidLinkNotification(notification: NSNotification) {
        dbButton.setTitle("Disconnect Dropbox", forState: UIControlState.Normal)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}