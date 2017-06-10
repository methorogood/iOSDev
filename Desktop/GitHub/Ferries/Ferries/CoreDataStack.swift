//
//  CoreDataStack.swift
//  iOS2-HW05
//
//  Created by Mark Thorogood on 5/24/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//
import Foundation
import CoreData

class CoreDataStack {
    
    static let sharedInstance = CoreDataStack()
    
    var appUpdateTimer: Timer?
    
    func beginContinuousUpdates() {
        appUpdateTimer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true, block: { (timer) in
            self.updatePositions()
        })
    }
    
    func endContinuousUpdates() {
        appUpdateTimer?.invalidate()
        appUpdateTimer = nil
    }
    
    func updatePositions() {
        print("Position data: starting update.")
        self.persistentContainer.performBackgroundTask { (privateContext) in
            // Do updates here
            do {
                try privateContext.save()
            } catch {
                print("Error updating position data: \(error)")
            }
        }
        print("Position data: completed update.")
    }
    
    var context: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Ferries")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print(container.name)
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
