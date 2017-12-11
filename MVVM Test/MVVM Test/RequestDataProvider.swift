//
//  RequestDataProvider.swift
//  MVVM Test
//
//  Created by Eugene Kuropatenko on 12/09/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation
import CoreData

class RequestDataProvider: NSObject, RequestViewModel {
    enum RequestViewModelChages {
        case insert
        case delete
    }

    var requestCount: Int {
        let section = resultController.sections![0]
        let count = section.numberOfObjects
        return count
    }
    
    weak fileprivate var delegate:RequestView?
    fileprivate var moc:NSManagedObjectContext {
        return AppDelegate.storageProvider.moc
    }
    
    fileprivate var resultController: NSFetchedResultsController<Request>!
    
    required init(_ delegate: RequestView) {
        super.init()
        let request = NSFetchRequest<Request>(entityName: "Request")
        request.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: false)]
        resultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        resultController.delegate = self
        self.delegate = delegate
        do {
            try resultController.performFetch()
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func requestFor(index:Int) -> RequestModel {
        let request = resultController.sections![0].objects![index] as! Request
        return request
    }
    
    func deleteRequest(request: RequestModel) {
        moc.delete(request as! NSManagedObject)
        AppDelegate.storageProvider.saveContext()
    }
    
}

extension RequestDataProvider : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)  {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                delegate?.update(type: .insert, indexPath: newIndexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                delegate?.update(type: .delete, indexPath: indexPath)
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.endUpdates()
    }
}
