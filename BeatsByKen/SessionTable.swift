//
//  SessionTable.swift
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
import CoreData

class SessionTable: NSManagedObject {

    @NSManaged var heartbeatCount: NSNumber
    @NSManaged var trialDuration: NSNumber
    @NSManaged var trialType: String
    @NSManaged var participantID: NSNumber
    @NSManaged var sessionID: NSNumber
    @NSManaged var tableViewRow: NSNumber
    @NSManaged var startTime: String
    @NSManaged var endTime: String

    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, heartbeatCount: NSNumber, trialDuration: NSNumber, startTime: String, endTime: String, trialType: String, participantID: NSNumber, sessionID: NSNumber, tableViewRow: NSNumber) -> SessionTable {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("SessionTable", inManagedObjectContext: moc) as! SessionTable
        newItem.heartbeatCount = heartbeatCount
        newItem.trialDuration = trialDuration
        newItem.trialType = trialType
        newItem.participantID = participantID
        newItem.sessionID = sessionID
        newItem.tableViewRow = tableViewRow
        newItem.startTime = startTime
        newItem.endTime = endTime
        var error: NSError? = nil
        moc.save(&error)
        return newItem
    }
    
    
    class func checkInManagedObjectContext(moc: NSManagedObjectContext, participantID: NSNumber, sessionID: NSNumber, tableViewRow: Int) -> Bool {
        
        let fetchRequest = NSFetchRequest(entityName: "SessionTable")
        let resultPredicate1 = NSPredicate(format: "participantID = %@", participantID )
        let resultPredicate2 = NSPredicate(format: "sessionID = %@", sessionID )
        let resultPredicate3 = NSPredicate(format: "tableViewRow = %d", tableViewRow )
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1, resultPredicate2, resultPredicate3])
        fetchRequest.predicate = compound
        var error: NSError? = nil
        let fetchResults = moc.executeFetchRequest(fetchRequest, error: &error) as? [SessionTable]
        if (fetchResults! != []) {
            return true
        } else {
            return false
        }
    }
    
    class func deleteInManagedObjectContext(moc: NSManagedObjectContext, participantID: NSNumber, sessionID: NSNumber, tableViewRow: NSNumber) -> Bool {
        
        let fetchRequest = NSFetchRequest(entityName: "SessionTable")
        let resultPredicate1 = NSPredicate(format: "participantID = %@", participantID )
        let resultPredicate2 = NSPredicate(format: "sessionID = %@", sessionID )
        let resultPredicate3 = NSPredicate(format: "tableViewRow = %@", tableViewRow )
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1, resultPredicate2, resultPredicate3])
        fetchRequest.predicate = compound
        var error: NSError? = nil
        let fetchResults = moc.executeFetchRequest(fetchRequest, error: &error) as? [SessionTable]
        if (fetchResults! != []) {
            moc.deleteObject(fetchResults![0])
            return true
        } else {
            return false
        }
    }
    
    class func getManagedObjectContext(moc: NSManagedObjectContext, participantID: NSNumber, sessionID: NSNumber) -> [NSManagedObject]? {
        
        let fetchRequest = NSFetchRequest(entityName: "SessionTable")
        let resultPredicate1 = NSPredicate(format: "participantID = %@", participantID )
        let resultPredicate2 = NSPredicate(format: "sessionID = %@", sessionID )
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1, resultPredicate2])
        let sortDescriptor = NSSortDescriptor(key: "tableViewRow", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = compound
        var error: NSError? = nil
        let fetchResults = moc.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        return fetchResults
    }
    
    
    
    // current trial settings are stored with trialSettingsPID and trialSettingsSID
    class func createTrialSettingInManagedObjectContext(moc: NSManagedObjectContext, heartbeatCount: NSNumber, trialDuration: NSNumber, startTime: String, endTime: String, trialType: String, participantID: NSNumber, sessionID: NSNumber, tableViewRow: NSNumber) -> SessionTable {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("SessionTable", inManagedObjectContext: moc) as! SessionTable
        newItem.heartbeatCount = heartbeatCount
        newItem.trialDuration = trialDuration
        newItem.trialType = trialType
        newItem.participantID = participantID
        newItem.sessionID = sessionID
        newItem.tableViewRow = tableViewRow
        newItem.startTime = startTime
        newItem.endTime  = endTime
        var error: NSError? = nil
        moc.save(&error)
        return newItem
    }
    
    class func updateCurrentSetting(moc: NSManagedObjectContext, heartbeatCount: NSNumber, trialDuration: NSNumber, startTime: String, endTime: String, trialType: String, participantID: NSNumber, sessionID: NSNumber, tableViewRow: NSNumber) -> SessionTable {
        let fetchRequest = NSFetchRequest(entityName: "SessionTable")
        let resultPredicate1 = NSPredicate(format: "participantID = %@", participantID )
        let resultPredicate2 = NSPredicate(format: "sessionID = %@", sessionID )
        let resultPredicate3 = NSPredicate(format: "trialType = %@", trialType)
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1, resultPredicate2, resultPredicate3])
        let sortDescriptor = NSSortDescriptor(key: "tableViewRow", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = compound
        var error: NSError? = nil
        let fetchResults = moc.executeFetchRequest(fetchRequest, error: &error) as? [SessionTable]
        if (fetchResults! != []) {
            moc.deleteObject(fetchResults![0])
            
            return createInManagedObjectContext(moc, heartbeatCount: heartbeatCount, trialDuration: trialDuration, startTime: startTime, endTime: endTime, trialType: trialType, participantID: participantID, sessionID: sessionID, tableViewRow: tableViewRow)
            
        } else {
            return createInManagedObjectContext(moc, heartbeatCount: heartbeatCount, trialDuration: trialDuration, startTime: startTime, endTime: endTime, trialType: trialType, participantID: participantID, sessionID: sessionID, tableViewRow: tableViewRow)
        }
    }
    class func getCurrentSettings(moc: NSManagedObjectContext, participantID: NSNumber, sessionID: NSNumber) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest(entityName: "SessionTable")
        let resultPredicate1 = NSPredicate(format: "participantID = %@", participantID )
        let resultPredicate2 = NSPredicate(format: "sessionID = %@", sessionID )
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1, resultPredicate2])
        let sortDescriptor = NSSortDescriptor(key: "tableViewRow", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = compound
        var error: NSError? = nil
        let fetchResults = moc.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        return fetchResults
    }
    
//    class func getCurrentSettings(moc: NSManagedObjectContext, participantID: NSNumber, sessionID: NSNumber) -> [NSManagedObject]? {
//        let fetchRequest = NSFetchRequest(entityName: "SessionTable")
//        let resultPredicate1 = NSPredicate(format: "participantID = %@", participantID )
//        let resultPredicate2 = NSPredicate(format: "sessionID = %@", sessionID )
//        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1, resultPredicate2])
//        let sortDescriptor = NSSortDescriptor(key: "tableViewRow", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        fetchRequest.predicate = compound
//        var error: NSError? = nil
//        let fetchResults = moc.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
//        return fetchResults
//    }
    
    
    
    
    
    
    
    func csv() -> String {
        let coalescedTrialType = trialType ?? ""
        let coalescedTrialDuration = String(trialDuration.intValue) ?? ""
        let coalescedHeartbeatCount = String(heartbeatCount.intValue) ?? ""
        
        return "\(coalescedTrialType)," +
            "\(coalescedTrialDuration),\(coalescedHeartbeatCount)\n"
    }
    
}
