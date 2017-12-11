//
//  Request+CoreDataProperties.swift
//  MVVM Test
//
//  Created by Eugene Kuropatenko on 12/09/17.
//  Copyright © 2017 Home. All rights reserved.
//
//

import Foundation
import CoreData


extension Request: RequestModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Request> {
        return NSFetchRequest<Request>(entityName: "Request")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var results: NSSet?

}

// MARK: Generated accessors for results
extension Request {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: Result)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: Result)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}
