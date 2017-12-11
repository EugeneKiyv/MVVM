//
//  StorageProvider.swift
//  MVVM Test
//
//  Created by Eugene Kuropatenko on 12/09/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation
import CoreData

class StorageProvider:StorageProviderModel {
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MVVM_Test")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var moc:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteObject(_ object:NSManagedObject) {
        moc.delete(object)
        saveContext()
    }
}

extension StorageProvider {
    func createRequest(text:String) -> RequestModel {
        let dbRequest = Request(context: moc)
        dbRequest.date = NSDate()
        dbRequest.name = text

        return dbRequest
    }
    
    func addResult(_ result:ResultModel, toRequest request:RequestModel) {
        (request as? Request)?.addToResults(result as! Result)
    }
    
    func createResult(title:String, path:String, description:String, stars:Int16) -> ResultModel {
        let result = Result(context: moc)
        result.title = title.substring(toIndex: 30)
        result.path = path
        result.stars = stars
        result.descr = description.substring(toIndex: 30)
        return result
    }
}
