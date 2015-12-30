//
//  DropboxSyncService.swift
//  BeatsByKen
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
// Modified from original at: https://robots.thoughtbot.com/using-the-dropbox-objectivec-api-in-swift

import Foundation
import UIKit

enum Result<A> {
    case Success(Box<A>)
    case Error(NSError)
    
    static func success(v: A) -> Result<A> {
        return .Success(Box(v))
    }
    
    static func error(e: NSError) -> Result<A> {
        return .Error(e)
    }
}

final class Box<A> {
    let value: A
    
    init(_ value: A) {
        self.value = value
    }
}

/////////////////////////////
// DBFilesystem extension
/////////////////////////////
extension DBFilesystem {
    func listFolder(path: DBPath) -> Result<[DBFileInfo]> {
        var error: DBError?
        let files = listFolder(path, error: &error)
        
        switch error {
        case .None: return .success(files as! [DBFileInfo])
        case let .Some(err): return .error(err)
        }
    }
    func openFile(path: DBPath) -> Result<DBFile> {
        var error: DBError?
        let file = openFile(path, error: &error)
        
        switch error {
        case .None: return .success(file)
        case let .Some(err): return .error(err)
        }
    }
    
    func createFile(path: DBPath) -> Result<DBFile> {
        var error: DBError?
        let file = createFile(path, error: &error)
        
        switch error {
        case .None: return .success(file)
        case let .Some(err): return .error(err)
        }
    }
}

/////////////////////////////
// DBFile extension
/////////////////////////////
extension DBFile {
    func readData() -> Result<NSData> {
        var error: DBError?
        let data = readData(&error)
        
        switch error {
        case .None: return .success(data)
        case let .Some(err): return .error(err)
        }
    }
    
    func writeData(data: NSData) -> Result<()> {
        var error: DBError?
        writeData(data, error: &error)
        
        switch error {
        case .None: return .success(())
        case let .Some(err): return .error(err)
        }
    }
}

/////////////////////////////
// custom swift functions yo
/////////////////////////////
infix operator >>- { associativity left precedence 150 }

func >>-<A, B>(a: A?, f: A -> B) -> B? {
    switch a {
    case let .Some(x): return f(x)
    case .None: return .None
    }
}

infix operator <^> { associativity left precedence 150 }

func <^><A, B>(f: A -> B, a: Result<A>) -> Result<B> {
    switch a {
    case let .Success(aBox): return .success(f(aBox.value))
    case let .Error(err): return .error(err)
    }
}

func >>-<A, B>(a: Result<A>, f: A -> Result<B>) -> Result<B> {
    switch a {
    case let .Success(aBox): return f(aBox.value)
    case let .Error(err): return .error(err)
    }
}

/////////////////////////////
/////////////////////////////
// DropboxSyncService class
/////////////////////////////
class DropboxSyncService {
    func setup() {
        let accountManager = DBAccountManager(appKey: dbkey, secret: dbsecret)
        DBAccountManager.setSharedManager(accountManager)
        if let linkedAccount = DBAccountManager.sharedManager().linkedAccount {
            println("Account already linked")
            DBFilesystem.setSharedFilesystem(DBFilesystem(account: DBAccountManager.sharedManager().linkedAccount))
        }

        
    }
    
    func isLinked() -> Bool{
        if let linkedAccount = DBAccountManager.sharedManager().linkedAccount {
            return true
        }
        else{
            return false
        }
    }
    
    func unlinkAll(){
        let linkedAccount = DBAccountManager.sharedManager().linkedAccount
        linkedAccount.unlink()
    }
    
    func getProgress() -> Float{
        let fileStatus = DBFileStatus()
        return fileStatus.progress
    }
    
    
    func initiateAuthentication(viewController: UIViewController) {
        if let linkedAccount = DBAccountManager.sharedManager().linkedAccount {
            println("Account already linked")
        }
        else {
            DBAccountManager.sharedManager().linkFromController(viewController)
            //DBFilesystem.setSharedFilesystem(DBFilesystem(account: DBAccountManager.sharedManager().linkedAccount))
        }
    }
    
    func finalizeAuthentication(url: NSURL) -> Bool {
        let account = DBAccountManager.sharedManager().handleOpenURL(url)
        DBFilesystem.setSharedFilesystem(DBFilesystem(account: account))
        
        if (DBAccountManager.sharedManager().linkedAccount.linked == true){
            NSNotificationCenter.defaultCenter().postNotificationName("didLinkToDropboxAccountNotification", object: nil)
        }
        
        return account != .None
    }
    
    func getFile(filename: String) -> Result<NSData> {
        let path = DBPath.root().childPath(filename)
        return DBFilesystem.sharedFilesystem().openFile(path) >>- { $0.readData() }
    }
    
    func getFiles() -> Result<[String]> {
        //DBFilesystem.setSharedFilesystem(DBFilesystem(account: DBAccountManager.sharedManager().linkedAccount))
        let fileInfos = DBFilesystem.sharedFilesystem().listFolder(DBPath.root())
        let filePaths: [DBFileInfo] -> [String] = { $0.map { $0.path.stringValue() } }
        return filePaths <^> fileInfos
    }
    
    func saveFile(filename: String, data: NSData) -> Result<()> {
        //println(testing())
        //DBFilesystem.setSharedFilesystem(DBFilesystem(account: DBAccountManager.sharedManager().linkedAccount))
        let path = DBPath.root().childPath(filename)
        return DBFilesystem.sharedFilesystem().createFile(path) >>- { $0.writeData(data) }
    }
    
    func testing() -> Bool {
        //DBFilesystem.setSharedFilesystem(DBFilesystem(account: DBAccountManager.sharedManager().linkedAccount))
        return DBFilesystem.sharedFilesystem().completedFirstSync
    }
}