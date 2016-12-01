//
//  Review+CoreDataProperties.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/30/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review");
    }

    @NSManaged public var biasRating: Float
    @NSManaged public var feedbackText: String?
    @NSManaged public var id: Int32
    @NSManaged public var recommendation: Int32
    @NSManaged public var question: Question?
    @NSManaged public var reviewer: User?

}
