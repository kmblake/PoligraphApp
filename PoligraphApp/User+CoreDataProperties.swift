//
//  User+CoreDataProperties.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 11/17/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var id: Int32
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var bio: String?
    @NSManaged public var credentials: String?
    @NSManaged public var askedQuestions: NSSet?
    @NSManaged public var answeredQuestions: NSSet?
    @NSManaged public var reviews: NSSet?

}

// MARK: Generated accessors for askedQuestions
extension User {

    @objc(addAskedQuestionsObject:)
    @NSManaged public func addToAskedQuestions(_ value: Question)

    @objc(removeAskedQuestionsObject:)
    @NSManaged public func removeFromAskedQuestions(_ value: Question)

    @objc(addAskedQuestions:)
    @NSManaged public func addToAskedQuestions(_ values: NSSet)

    @objc(removeAskedQuestions:)
    @NSManaged public func removeFromAskedQuestions(_ values: NSSet)

}

// MARK: Generated accessors for answeredQuestions
extension User {

    @objc(addAnsweredQuestionsObject:)
    @NSManaged public func addToAnsweredQuestions(_ value: Question)

    @objc(removeAnsweredQuestionsObject:)
    @NSManaged public func removeFromAnsweredQuestions(_ value: Question)

    @objc(addAnsweredQuestions:)
    @NSManaged public func addToAnsweredQuestions(_ values: NSSet)

    @objc(removeAnsweredQuestions:)
    @NSManaged public func removeFromAnsweredQuestions(_ values: NSSet)

}

// MARK: Generated accessors for reviews
extension User {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}
