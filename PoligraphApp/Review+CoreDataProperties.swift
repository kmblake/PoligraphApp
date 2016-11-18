//
//  Review+CoreDataProperties.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 11/17/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import Foundation
import CoreData

extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review");
    }

    @NSManaged public var feedbackText: String?
    @NSManaged public var recommendation: Int32
    @NSManaged public var biasRating: Double
    @NSManaged public var question: Question?
    @NSManaged public var reviewer: User?

}
