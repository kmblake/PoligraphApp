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
    
    
    /* Question.StatusTypes
        
     Enumerates the various statuses that questions can have:
        0: An asked question has not been answered.
        1: An unfinished answer is an answer in the process of being written.
        2: An answered question has not been reviewed.
        3: A reviwed question has been reviwed and approved. Only reviwed questions show in the browse.
     These are stored in core data as integers, so when adding to core data or getting a predicate for them,
     use type.rawValue to access the underlying integer
     
    */
    enum StatusTypes: Int {
        case asked = 0
        case unfinishedAnswer
        case answered
        case reviewed
    }
    
    class func printAllQuestions(inManagedObjectContext context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        
        if let questions = (try? context.fetch(request)) as? [Question] {
            print("\n Total Number of Questions: \(questions.count)")
            for question in questions {
                print("\n Question ID: \(question.id)")
                print("Text: \(question.text!)")
                print("Summary: \(question.summary)")
            }
            print("\n")
        } else {
            print("Question retrival failed")
        }
    }
    
    class func loadQuestions(withStatus status: Question.StatusTypes, inManagedObjectContext context: NSManagedObjectContext) -> [Question]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        request.predicate = NSPredicate(format: "status == %i", status.rawValue)
        
        if let questions = (try? context.fetch(request)) as? [Question] {
            return questions
        }
        return nil
    }
    
    class func loadQuestions(withStatus status: Question.StatusTypes, excludingUser user: User, inManagedObjectContext context: NSManagedObjectContext) -> [Question]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        if status == StatusTypes.asked {
            request.predicate = NSPredicate(format: "status == %i AND asker.id != %i", status.rawValue, user.id)
        } else if status == StatusTypes.answered {
            var ids = [Int32]()
            if let reviews = Review.loadReviews(forUser: user) {
                for review in reviews {
                    ids.append(review.question!.id)
                }
            }
            //request.predicate = NSPredicate(format: "status == %i AND asker.id != %i AND answerer.id != %i", status.rawValue, user.id, user.id)
            request.predicate = NSPredicate(format: "status == %i AND asker.id != %i AND answerer.id != %i AND NOT (id in %@)", status.rawValue, user.id, user.id, ids)
        } else {
            request.predicate = NSPredicate(format: "status == %i", status.rawValue)
        }
        
        if let questions = (try? context.fetch(request)) as? [Question] {
            return questions
        }
        return nil
    }
    
    class func loadUnansweredQuestions(forUser user: User) -> [Question]? {
        if let userQuestions = user.askedQuestions {
            if let questionsArray = Array(userQuestions) as?  [Question] {
                //TODO: Optionally sort these by status
                return questionsArray
            }
        }
        return nil
    }
    
    class func loadAnsweredQuestions(forUser user: User) -> [Question]? {
        if let answeredQuestions = user.answeredQuestions {
            if let questionsArray = Array(answeredQuestions) as? [Question] {
                return questionsArray
            }
        }
        return nil
    }
    
    class func loadReviewedQuestions(forUser user: User) -> [Question]? {
        if let reviews = user.reviews {
            var reviewedQuestions = [Question]()
            if let reviewArray = Array(reviews) as? [Review] {
                print("Loaded \(reviewArray.count) reviewed questions")
                for review in reviewArray {
                    reviewedQuestions.append(review.question!)
                }
            }
            return reviewedQuestions
        }
        return nil
    }

    /* Search Questions
     
     API to search a question for certain text (case insensitively) and question type.
     
     Returns: optional array of Questions
    
    */
    class func searchQuestions(withStatus status: Question.StatusTypes?, text: String, inManagedObjectContext context: NSManagedObjectContext) -> [Question]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        if let status = status {
            request.predicate = NSPredicate(format: "(status == %i) AND (text contains[c] %@)", status.rawValue, text)
        } else {
            request.predicate = NSPredicate(format: "text contains[c] %@", text)
        }
        
        if let questions = (try? context.fetch(request)) as? [Question] {
            return questions
        }
        
        return nil
    }
    
    class func addAskedQuestion(asker: User, text: String, inManagedObjectContext context: NSManagedObjectContext) -> Question? {
        
        let idRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        idRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        idRequest.sortDescriptors = [sortDescriptor]
        
        var maxQuestionID = Int32(50) //TODO could use better value
        if let question = (try? context.fetch(idRequest))?.first as? Question {
            maxQuestionID = question.id + 1
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        request.predicate = NSPredicate(format: "text == %@", text) //TODO: Make case-insensitive
        
        if let question = (try? context.fetch(request))?.first as? Question {
            print("Error: That question already exists.")
            return question
        } else if let question = NSEntityDescription.insertNewObject(forEntityName: "Question", into: context) as? Question {
            question.text = text
            question.asker = asker
            question.status = Int32(StatusTypes.asked.rawValue)
            question.id = maxQuestionID
            question.userDidUpvote = true
            return question
        }
        
        return nil
    }

}
