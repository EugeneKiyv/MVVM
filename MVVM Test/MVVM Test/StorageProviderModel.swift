//
//  StorageProviderModel.swift
//  MVVM Test
//
//  Created by Eugene Kuropatenko on 12/09/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation
import CoreData

protocol StorageProviderModel {
    func createRequest(text:String) -> RequestModel
    func createResult(title:String, path:String, description:String, stars:Int16) -> ResultModel
    func addResult(_ result:ResultModel, toRequest:RequestModel)
    
    var moc:NSManagedObjectContext {get}
    func saveContext()
    func deleteObject(_ object:NSManagedObject)
}

protocol RequestModel {
    var name: String? {get set}
    var date: NSDate? {get set}
    var results: NSSet? {get set}
}

protocol ResultModel {
    var title: String? {get set}
    var path: String? {get set}
    var stars: Int16 {get set}
    var descr: String? {get set}
}
