//
//  Question+CoreDataProperties.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/21/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question");
    }

    @NSManaged public var answer: String?
    @NSManaged public var biasRating: Float
    @NSManaged public var id: Int32
    @NSManaged public var image: String?
    @NSManaged public var status: Int32
    @NSManaged public var summary: String?
    @NSManaged public var text: String?
    @NSManaged public var upvotes: Int32
    @NSManaged public var answerer: User?
    @NSManaged public var asker: User?
    @NSManaged public var reviews: NSSet?

}

// MARK: Generated accessors for reviews
extension Question {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}
