//
//  Result+CoreDataProperties.swift
//  MVVM Test
//
//  Created by Eugene Kuropatenko on 12/09/17.
//  Copyright © 2017 Home. All rights reserved.
//
//

import Foundation
import CoreData


extension Result: ResultModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Result> {
        return NSFetchRequest<Result>(entityName: "Result")
    }

    @NSManaged public var title: String?
    @NSManaged public var path: String?
    @NSManaged public var stars: Int16
    @NSManaged public var request: Request?
    @NSManaged public var descr: String?

}
