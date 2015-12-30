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
// Export CSV based on:
// http://www.raywenderlich.com/84642/multiple-managed-object-contexts-in-core-data-tutorial

import UIKit
import CoreData

class SessionSummaryView: UIViewController {
    @IBOutlet var confirmButton: UIButton!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var participantID = 0;
    var sessionID = 0;
    var fileName = ""
    var exportFilePath = ""
    let dropboxSyncService = (UIApplication.sharedApplication().delegate as! AppDelegate).dropboxSyncService
    
        
    @IBAction func buttonPressed() {
       // exportCSVFile()
        
        if let fileContent = NSFileManager.defaultManager().contentsAtPath(self.exportFilePath) {
            dropboxSyncService.saveFile(self.fileName, data: fileContent)
            println("tryna save")
        }
        else {
            println("No go")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dropboxSyncService.initiateAuthentication(self)
        
        println("in session summary")
        println(participantID)
        println(sessionID)
        self.navigationItem.hidesBackButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func exportCSVFile() {
//        // 1: retrieve all SessionTable objects for this participantID and sessionID
//        var fetchRequestError: NSError? = nil
//        let results = SessionTable.getManagedObjectContext(managedObjectContext!, participantID: participantID, sessionID: sessionID)
//        if results == nil {
//            println("ERROR: \(fetchRequestError)")
//        }
//        
//        // 2
//        self.fileName = String(self.participantID) + String(self.sessionID) + ".csv"
//        self.exportFilePath = NSTemporaryDirectory() + self.fileName
//        let exportFileURL = NSURL(fileURLWithPath: self.exportFilePath)!
//        NSFileManager.defaultManager().createFileAtPath(self.exportFilePath, contents: NSData(), attributes: nil)
//        println(self.exportFilePath)
//        
//        // 3
//        var fileHandleError: NSError? = nil
//        let fileHandle = NSFileHandle(forWritingToURL: exportFileURL, error: &fileHandleError)
//        if let fileHandle = fileHandle {
//            
//            // 4
//            for object in results! {
//                let summaryRow = object as SessionTable
//                
//                fileHandle.seekToEndOfFile()
//                let csvData = summaryRow.csv().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
//                fileHandle.writeData(csvData!)
//            }
//            
//            // 5
//            fileHandle.closeFile()
//        }
//        println("ayyyy")
//    }
}