//
//  CoreDataManager.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/16/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LovooTask")
        container.loadPersistentStores(completionHandler: { (storeDiscription, error) in
            if let error = error {
                fatalError("error in loading of stores failed: \(error)")
            }
        })
        return container
    }()
    
    lazy private var context = persistentContainer.viewContext
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print("couldn;t save to coreData -->\(error)")
            }
        }
    }
    
    func removeAll() {
        let fetchRequest = NSFetchRequest<Bookable>.init(entityName: "Bookable")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}
