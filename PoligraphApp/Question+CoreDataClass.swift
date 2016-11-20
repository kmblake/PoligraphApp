//
//  Question+CoreDataClass.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 11/17/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import Foundation
import CoreData


public class Question: NSManagedObject {
    
    
    /*
        An asked question has not been answered.
        An answered question has not been reviewed.
        A reviwed question has been reviwed and approved. Only reviwed questions show in the browse.
 
    */
    enum StatusTypes: Int {
        case asked
        case answered
        case reviwed
    }

//    class func questionsWithText(searchString: String, inManagedObjectContext context: NSManagedObjectContext) -> Question? {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
//        request.predicate = NSPredicate(format: "text contains[c] %@", searchString)
//        
//        if let question = (try? context.fetch(request))?.first as? Question {
//            return question
//        }
//        
//        return nil
//    }
    
    class func searchQuestions(type: Question.StatusTypes, text: String, inManagedObjectContext context: NSManagedObjectContext) -> [Question]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        request.predicate = NSPredicate(format: "(status == %i) AND (text contains[c] %@)", StatusTypes.asked.rawValue, text)
        
        if let questions = (try? context.fetch(request)) as? [Question] {
            return questions
        }
        
        return nil
    }
    
    class func addQuestion(asker: User, text: String, inManagedObjectContext context: NSManagedObjectContext) -> Question? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        request.predicate = NSPredicate(format: "text[c] = %@", text)
        
        if let question = (try? context.fetch(request))?.first as? Question {
            //TODO: This happens if question is already in database. Decide what to do here
            return question
        } else if let question = NSEntityDescription.insertNewObject(forEntityName: "Question", into: context) as? Question {
            question.text = text
            question.asker = asker
            question.status = 0 //TODO: Make this a nice enum
            //TODO: What's the status of the bias rating? Should be nil
            
            //Note that this doesn't add: answer, summary, image, biasRating, upvotes, answerer, or reviews
        }
        
        return nil
    }

}
