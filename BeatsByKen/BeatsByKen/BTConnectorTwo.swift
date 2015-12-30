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
import CoreBluetooth

//The name is weird but we already had a BTConnector for most of development as a reference/dummy
//so we'll stick with Two as an acknowledgement of its greatness
class BTConnectorTwo: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    //Make class a singleotn. No idea if the argument is right
    static let sharedBTInstance = BTConnectorTwo(coder: NSCoder())
    
    var centralManager : CBCentralManager!
    
    //Life saving Obj-C function because we can't translate it
    var kickassCounter: beatCounter = beatCounter()
    
    //The service UUIDs we care about
    let serviceUUIDs:[AnyObject] = [CBUUID(string: "180D")]
    
    //The peripheral that we want to consistently connect to
    var connectingPeripheral : CBPeripheral!
    
    //List of all peripherals in range
    var availablePeripherals = [CBPeripheral]()
    
    //Timer to keep peripherals up to date
    var timer:NSTimer?
    
    var bpm:Int32 = 0;

    
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue : nil, options : nil)
    }
    
    // Reset Beat Count
    func resetBeatCount(){
        kickassCounter.resetRRCount()
    }
    
    // Get Beat Count
    func getBeatCount() -> Int32{
        return kickassCounter.getRRCount()
    }
    
    func getBPM() -> Int32{
        return bpm;
    }
 
    
    @objc func centralManagerDidUpdateState(central: CBCentralManager!){
        
        switch central.state{
        case .PoweredOn:
            println("poweredOn")
            
            enableAutomaticScan()
            
            //If we have preferred peripheral, connect, otherwsie just upadte list
            if availablePeripherals.count > 0{
                
                if connectingPeripheral != nil{
                    centralManager.connectPeripheral(connectingPeripheral, options: nil)
                }
            }
            else {
                centralManager.scanForPeripheralsWithServices(serviceUUIDs, options: nil)
            }
            
        default:
            println(central.state)
        }
    }
    
    //Get the list of available peripherals
    func getAvailablePeripherals() -> [CBPeripheral]{
        //print(availablePeripherals)
        if availablePeripherals.count > 0{
            return availablePeripherals
        }
        return []
    }
    
    //Get the name of currently connected peripheral
    func getCurrentPeripheral() -> String{
        if connectingPeripheral != nil {
            return connectingPeripheral.name
        }
        else{
            return "None"
        }
    }
    
    //Disconnect from currently connected device
    func disconnect(){
        if connectingPeripheral != nil{
            centralManager.cancelPeripheralConnection(connectingPeripheral)
            connectingPeripheral = nil
        }
    }
    
    //Update list of available peripherals (called on a timer)
    //User can turn this off with disableAutomaticScan()
    func refreshPeripherals(){
        println("Refreshing Peripherals")
        centralManager.stopScan()
        availablePeripherals.removeAll()
        centralManager.scanForPeripheralsWithServices(serviceUUIDs, options: nil)
    }
    
    // Method to manually stop scan
    func stopScanning(){
        centralManager.stopScan()
        println("Stopping Scan")
    }
    
    // Enables automatic peripheral scanning
    func enableAutomaticScan(){
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "refreshPeripherals", userInfo: nil, repeats: true)
    }
    
    // Disables automatic peripheral scanning
    func disableAutomaticScan(){
        timer?.invalidate()
    }
    
    //Connect to a peripheral and set it as preference
    func setAndConnectPeripheral(device:CBPeripheral){
        if connectingPeripheral != nil{
            centralManager.cancelPeripheralConnection(connectingPeripheral)
        }
        connectingPeripheral = device
        centralManager.connectPeripheral(connectingPeripheral, options:nil)
    }
    
    
    // Whenever a peripheral is found:
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        if !contains(availablePeripherals, peripheral){
            availablePeripherals.append(peripheral)
            peripheral.delegate = self
        }
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        
        peripheral.discoverServices(nil)
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        
        if let actualError = error{
            
        }
        else {
            for service in peripheral.services {
                peripheral.discoverCharacteristics(nil, forService: service as! CBService)
            }
        }
    }
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        connectingPeripheral = nil
        refreshPeripherals()
        
        // Notify user if connection is lost
        println("Connection Lost")
        let disconnectionAlert = UIAlertView()
        disconnectionAlert.title = "Warning"
        disconnectionAlert.message = "Heart rate sensor connection was lost"
        disconnectionAlert.addButtonWithTitle("Continue")
        disconnectionAlert.delegate = self
        disconnectionAlert.show()
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        
        if let actualError = error{
            
        }
        else {
            
            if service.UUID == CBUUID(string: "180D"){
                for characteristic in service.characteristics as! [CBCharacteristic]{
                    switch characteristic.UUID.UUIDString{
                        
                    case "2A00":
                        //Identify device name to keep track of which is which
                        println("Found a unique name")
                        peripheral.readValueForCharacteristic(characteristic)
                        
                    case "2A37":
                        // Set notification on heart rate measurement
                        println("Found a Heart Rate Measurement Characteristic")
                        peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                        
                    case "2A38":
                        // Read body sensor location
                        println("Found a Body Sensor Location Characteristic")
                        peripheral.readValueForCharacteristic(characteristic)
                        
                    case "2A39":
                        // Write heart rate control point
                        println("Found a Heart Rate Control Point Characteristic")
                        
                        var rawArray:[UInt8] = [0x01];
                        let data = NSData(bytes: &rawArray, length: rawArray.count)
                        peripheral.writeValue(data, forCharacteristic: characteristic, type: CBCharacteristicWriteType.WithoutResponse)
                        
                    default:
                        println()
                    }
                }
            }
        }
    }
    

    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        if let actualError = error{
            
        }else {
            switch characteristic.UUID.UUIDString{
            case "2A37":
                kickassCounter.getHeartBPMData(characteristic , error: error)
                bpm = kickassCounter.getBPM(characteristic, error: error)
            default:
                println()
            }
        }
    }
}