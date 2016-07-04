//
//  CDHelper.swift
//
//  Created by Tim Roadley on 29/09/2015.
//  Copyright © 2015 Tim Roadley. All rights reserved.
//

import UIKit
import CoreData

private let _sharedCDHelper = CDHelper()
class CDHelper : NSObject  {
    
    // MARK: - SHARED INSTANCE
    class var shared : CDHelper {
        return _sharedCDHelper
    }
    
    // MARK: - PATHS
    lazy var storesDirectory: NSURL? = {
        let fm = NSFileManager.defaultManager()
        let urls = fm.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    lazy var localStoreURL: NSURL? = {
        if let url = self.storesDirectory?.URLByAppendingPathComponent("LocalStore.sqlite") {
            print("localStoreURL = \(url)")
            return url
        }
        return nil
    }()
    lazy var iCloudStoreURL: NSURL? = {
        if let url = self.storesDirectory?.URLByAppendingPathComponent("iCloud.sqlite") {
            print("iCloudStoreURL = \(url)")
            return url
        }
        return nil
    }()
    lazy var sourceStoreURL: NSURL? = {
        if let url = NSBundle.mainBundle().URLForResource("DefaultData", withExtension: "sqlite") {
            print("sourceStoreURL = \(url)")
            return url
        }
        return nil
    }()
    lazy var seedStoreURL: NSURL? = {
        if let url = self.storesDirectory?.URLByAppendingPathComponent("LocalStore.sqlite") {
            print("seedStoreURL = \(url)")
            return url
        }
        return nil
    }()
    lazy var modelURL: NSURL = {
        let bundle = NSBundle.mainBundle()
//        if let url = bundle.URLForResource("Model", withExtension: "momd") {
//            return url
//        }
        if let url = bundle.URLForResource("_0_DWT_BB", withExtension: "momd") {
            return url
        }

        
        print("CRITICAL - Managed Object Model file not found")
        abort()
    }()
    
    // MARK: - CONTEXT
    lazy var parentContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.coordinator
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return moc
    }()
    lazy var context: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType:.MainQueueConcurrencyType)
        // moc.persistentStoreCoordinator = self.coordinator
        moc.parentContext = self.parentContext
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return moc
    }()
    lazy var importContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
        //moc.persistentStoreCoordinator = self.coordinator
        moc.parentContext = self.context
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return moc
    }()
    lazy var sourceContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
        //moc.persistentStoreCoordinator = self.coordinator
        moc.parentContext = self.context
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return moc
    }()
    lazy var seedContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.seedCoordinator
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return moc
    }()
    
    // MARK: - MODEL
    lazy var model: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOfURL:self.modelURL)!
    }()
        
    // MARK: - COORDINATOR
    lazy var coordinator: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel:self.model)
    }()
    lazy var sourceCoordinator:NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel:self.model)
    }()
    lazy var seedCoordinator:NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel:self.model)
    }()
        
    // MARK: - STORE
    lazy var localStore: NSPersistentStore? = {

        let useMigrationManager = false
        if let _localStoreURL = self.localStoreURL {        
            if useMigrationManager == true &&
                CDMigration.shared.storeExistsAtPath(_localStoreURL) &&
                CDMigration.shared.store(_localStoreURL, isCompatibleWithModel: self.model) == false {
                return nil // Don't return a store if it's not compatible with the model
            }
        }
        
        let options:[NSObject:AnyObject] = [//NSSQLitePragmasOption:["journal_mode":"DELETE"],
                                            NSMigratePersistentStoresAutomaticallyOption:1,
                                            NSInferMappingModelAutomaticallyOption:1]
        var _localStore:NSPersistentStore?
        do {
            _localStore = try self.coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.localStoreURL, options: options)
            return _localStore
        } catch {
            return nil
        }
    }()
    lazy var iCloudStore: NSPersistentStore? = {

       // Change contentNameKey for your own applications
        let contentNameKey = "MyApp"
        
        print("Using '\(contentNameKey)' as the iCloud Ubiquitous Content Name Key")
        let options:[NSObject:AnyObject] =
                    [NSMigratePersistentStoresAutomaticallyOption:1,
                     NSInferMappingModelAutomaticallyOption:1,
                     NSPersistentStoreUbiquitousContentNameKey:contentNameKey
                  //,NSPersistentStoreUbiquitousContentURLKey:"ChangeLogs" // Optional since iOS7
                    ]
        var _iCloudStore:NSPersistentStore?
        do {
            _iCloudStore = try self.coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.iCloudStoreURL,options: options)
            return _iCloudStore
        } catch {
            print("\(#function) ERROR adding iCloud store : \(error)")
            return nil
        }
    }()
    lazy var sourceStore: NSPersistentStore? = {
            
        let options:[NSObject:AnyObject] = [NSReadOnlyPersistentStoreOption:1]
            
        var _sourceStore:NSPersistentStore?
        do {
            _sourceStore = try self.sourceCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.sourceStoreURL, options: options)
            return _sourceStore
        } catch {
            return nil
        }
    }()
    lazy var seedStore: NSPersistentStore? = {
            
        let options:[NSObject:AnyObject] = [NSReadOnlyPersistentStoreOption:1]
            
        var _seedStore:NSPersistentStore?
        do {
            _seedStore = try self.seedCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.seedStoreURL, options: options)
            return _seedStore
        } catch {
            return nil
        }
    }()
    func unloadStore (ps:NSPersistentStore) -> Bool {
            
        if let psc = ps.persistentStoreCoordinator {
            
            do {
                try psc.removePersistentStore(ps)
                return true // Unload complete
            } catch {print("\(#function) ERROR removing persistent store : \(error)")}
        } else {print("\(#function) ERROR removing persistent store : store \(ps.description) has no coordinator")}
        return false // Fail
    }
    func removeFileAtURL (url:NSURL) {
          
        do {
            try NSFileManager.defaultManager().removeItemAtURL(url)
            print("Deleted \(url)")
        } catch { 
            print("\(#function) ERROR deleting item at url '\(url)' : \(error)")
        }
    }
    
    
    // MARK: - SETUP
    required override init() {
        super.init()
        self.setupCoreData()
        self.listenForStoreChanges()
    }
    func setupCoreData() {
            
        /*// Model Migration
        if let _localStoreURL = self.localStoreURL {
            CDMigration.shared.migrateStoreIfNecessary(_localStoreURL, destinationModel: self.model)
        } */

        // Load Local Store
        // self.setDefaultDataStoreAsInitialStore()
        //_ = self.sourceStore
        _ = self.localStore
            
        /*// Load iCloud Store
        if let _ = self.iCloudStore {
            
            // self.destroyAlliCloudDataForThisApplication()
            
            if let path = self.seedStoreURL?.path {
                // Merge existing data with iCloud
                if NSFileManager.defaultManager().fileExistsAtPath(path) {
                    if let _ = self.seedStore {
                        self.confirmMergeWithiCloud()
                    } else {print("Failed to instantiate seed store")}
                } else {print("Failed to find seed store at '\(path)'")}
            } else {print("Failed to prepare seed store path")}
        } else {print("Failed to load iCloud store")}*/
        
        // Import Default Data
        /* if let _localStoreURL = self.localStoreURL {
            CDImporter.shared.checkIfDefaultDataNeedsImporting(_localStoreURL, type: NSSQLiteStoreType)
        } else {print("ERROR getting localStoreURL in \(__FUNCTION__)")}*/
    }
        
    // MARK: - SAVING
    class func save(moc:NSManagedObjectContext) {
        
        moc.performBlockAndWait {
         
            if moc.hasChanges {
            
                do {
                    try moc.save()
                    //print("SAVED context \(moc.description)")
                } catch {
                    print("ERROR saving context \(moc.description) - \(error)")
                }
            } else {
                //print("SKIPPED saving context \(moc.description) because there are no changes")
            }
            if let parentContext = moc.parentContext {
                save(parentContext)
            }
        }
    }
    class func saveSharedContext() {
        save(shared.context) 
    }
    
    // MARK: - DEFAULT STORE
    func setDefaultDataStoreAsInitialStore () {
            
        if let url = self.localStoreURL, path = url.path {
            if NSFileManager.defaultManager().fileExistsAtPath(path) == false {
                if let defaultDataURL = NSBundle.mainBundle().URLForResource("DefaultData", withExtension: "sqlite") {
                    do {
                        try NSFileManager.defaultManager().copyItemAtURL(defaultDataURL, toURL: url)
                        print("A copy of DefaultData.sqlite was set as the initial store for \(url)")
                    } catch {
                        print("\(#function) ERROR setting DefaultData.sqlite as the initial store: : \(error)")
                    }
                } else {print("\(#function) ERROR: Could not find DefaultData.sqlite in the application bundle.")}
            } 
        } else {print("\(#function) ERROR: Failed to prepare URL in \(#function)")}
    } 
    
    // MARK: - ICLOUD
    func iCloudAccountIsSignedIn() -> Bool {
            
        if let token = NSFileManager.defaultManager().ubiquityIdentityToken {
            print("** This device is SIGNED IN to iCloud with token \(token) **")
            return true
        }
            
        print("\rThis application cannot use iCloud because it is either signed out or is disabled for this App.")
        print("If the device is signed in and you still get this error, verify the following:")
        print("1) iCloud Documents is ticked in Xcode (Application Target > Capabilities > iCloud.)")
        print("2) The App ID is enabled for iCloud in the Member Center (https://developer.apple.com/)")
        print("3) The App is enabled for iCloud on the Device (Settings > iCloud > iCloud Drive)")
        return false
    }
    func listenForStoreChanges () {
        let dc = NSNotificationCenter.defaultCenter()
        dc.addObserver(self, selector: #selector(CDHelper.storesWillChange(_:)), name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: self.coordinator)
        dc.addObserver(self, selector: #selector(CDHelper.storesDidChange(_:)), name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: self.coordinator)
        dc.addObserver(self, selector: #selector(CDHelper.iCloudDataChanged(_:)), name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object:self.coordinator)
    }
    func storesWillChange (note:NSNotification) {
            
        self.sourceContext.performBlockAndWait {
            do {
                try self.sourceContext.save()
                self.sourceContext.reset()
            } catch {print("ERROR saving sourceContext \(self.sourceContext.description) - \(error)")}
        }
        self.importContext.performBlockAndWait {
            do {
                try self.importContext.save()
                self.importContext.reset()
            } catch {print("ERROR saving importContext \(self.importContext.description) - \(error)")}
        }
        self.context.performBlockAndWait {
            do {
                try self.context.save()
                self.context.reset()
            } catch {print("ERROR saving context \(self.context.description) - \(error)")}
        }
        self.parentContext.performBlockAndWait {
            do {
                try self.parentContext.save()
                self.parentContext.reset()
            } catch {print("ERROR saving parentContext \(self.parentContext.description) - \(error)")}
        }
    }
    func storesDidChange (note:NSNotification) {
            
        // Refresh UI
        NSNotificationCenter.defaultCenter().postNotificationName("SomethingChanged", object: nil)
    }
    func iCloudDataChanged (note:NSNotification) {

        // Refresh UI Context
        self.context.mergeChangesFromContextDidSaveNotification(note)
        NSNotificationCenter.defaultCenter().postNotificationName("SomethingChanged", object: nil) 
    }
    func seedDataToiCloud () {
            
        self.seedContext.performBlock {
            
            print("*** STARTED DEEP COPY FROM SEED STORE TO ICLOUD STORE ***")
            _ = self.seedStore
            let entities = ["LocationAtHome","LocationAtShop","Unit","Item"]
            CDImporter.deepCopyEntities(entities, from: self.seedContext, to: self.importContext)

            self.context.performBlock {
                    
                NSNotificationCenter.defaultCenter().postNotificationName("SomethingChanged", object: nil)
                print("*** FINISHED DEEP COPY FROM SEED STORE TO ICLOUD STORE ***")
                
                // Remove seed store
                if let _seedStoreURL = self.seedStoreURL {
                       
                    if let wal = _seedStoreURL.path?.stringByAppendingString("-wal") {
                        self.removeFileAtURL(NSURL(fileURLWithPath: wal))
                    }
                        
                    if let shm = _seedStoreURL.path?.stringByAppendingString("-shm") {
                        self.removeFileAtURL(NSURL(fileURLWithPath: shm))
                    }
                    self.removeFileAtURL(_seedStoreURL)
                }
            }
        }
    }
    func confirmMergeWithiCloud () {
            
        if let path = self.seedStoreURL?.path {
        
            if NSFileManager.defaultManager().fileExistsAtPath(path) {
                
                let alert = UIAlertController(title: "Merge with iCloud?", message: "This will move your existing data into iCloud.", preferredStyle: .Alert)
                let mergeButton = UIAlertAction(title: "Merge", style: .Default, handler: { (action) -> Void in
                    
                    self.seedDataToiCloud()
                })
                let dontMergeButton = UIAlertAction(title: "Don't Merge", style: .Default, handler: { (action) -> Void in
                    
                    // Don't do anything. In your own applications, store this decision.
                })
                alert.addAction(mergeButton)
                alert.addAction(dontMergeButton)
                
                // PRESENT
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let initialVC = UIApplication.sharedApplication().keyWindow?.rootViewController {
                        initialVC.presentViewController(alert, animated: true, completion: nil)
                    } else {print("%@ FAILED to prepare the initial view controller",#function)}
                })
                
            } else {
                print("Skipped unnecessary migration of seed store to iCloud (there's no store file).")
            }
        } 
    }
    
    // MARK: - ICLOUD RESET (only for use during testing, not production)
    func destroyAlliCloudDataForThisApplication () {

        print("Attempting to destroy all iCloud content for this application, which could take a while...")
        let persistentStoreCoordinators = [self.coordinator,self.seedCoordinator,self.sourceCoordinator]
        for persistentStoreCoordinator in persistentStoreCoordinators {
            for persistentStore in persistentStoreCoordinator.persistentStores {
                self.unloadStore(persistentStore)
            }
        }

        if let _iCloudStoreURL = self.iCloudStoreURL {
        
            do {
                
                let options = [NSPersistentStoreUbiquitousContentNameKey:"MyApp"]
                try NSPersistentStoreCoordinator.removeUbiquitousContentAndPersistentStoreAtURL(_iCloudStoreURL, options: options)
                print("\n\n\n")
                print("*          This application's iCloud content has been destroyed.          *")
                print("*   On ALL devices, please delete any reference to this application from  *")
                print("*                      Settings > iCloud > Storage                        *")
                print("*                                                                         *")
                print("* The application is force closed to ensure iCloud data is wiped cleanly. *")
                print("\n\n\n")
                abort()
                
            } catch {print("\n\n FAILED to destroy iCloud content - \(error)")}
        } else {print("\n\n FAILED to destroy iCloud content because _iCloudStoreURL is nil.")}
    }
    
}
