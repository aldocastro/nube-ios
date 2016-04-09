//
//  CoreDataStack.swift
//  BookFinder
//
//  Created by Aldo Castro on 23/03/16.
//  Copyright © 2016 Aldo Castro. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    let context: NSManagedObjectContext
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    let model: NSManagedObjectModel
    let store: NSPersistentStore
    
    init() {
        let urlResourceName = "Book Finder"
        let bundle = NSBundle.mainBundle()
        let modelURL = bundle.URLForResource(urlResourceName, withExtension: "momd")
        model = NSManagedObjectModel(contentsOfURL: modelURL!)!
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        let documentsURL = CoreDataStack.applicationDocumentsDirectory()
        let storeURL = documentsURL.URLByAppendingPathComponent(urlResourceName)
        let options = [NSMigratePersistentStoresAutomaticallyOption: true]
        do {
            store = try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        } catch {
            print("\(error)")
            abort()
        }
    }
    
    static func applicationDocumentsDirectory() -> NSURL {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        return urls[0]
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Could not save: \(error)")
            }
        }
    }
    
    
}