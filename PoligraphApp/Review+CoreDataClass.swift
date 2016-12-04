//
//  Review+CoreDataClass.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 11/17/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import Foundation
import CoreData


public class Review: NSManagedObject {
    
    static let RecommendationTypes: [String: Int32] = [
        "Accept": 0,
        "Needs Revision": 1,
        "Reject": 2
    ]

    /* Add New Review
        Adds a new review to the Model database, populating it wth all the provided info. Returns the review, or nil if there's an error. Intended for use preloading data. The in-app review creation process would be different.
            Includes all info to fully define review, no other attributes need to be added.
 
    */
    class func addNewReview(feedbackText: String, recommendation: Int32, biasRating: Float, question: Question, reviewer: User, inManagedObjectContext context: NSManagedObjectContext) -> Review? {
        
        if let review = NSEntityDescription.insertNewObject(forEntityName: "Review", into: context) as? Review {
            review.feedbackText = feedbackText
            review.recommendation = recommendation
            review.biasRating = biasRating
            review.question = question
            review.reviewer = reviewer
            
            if question.reviews?.count == 3 {
                //TODO: Calculation, or just send along
            }
            
            return review
        }
        
        return nil
    }
}
