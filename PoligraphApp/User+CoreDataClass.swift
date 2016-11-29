//
//  User+CoreDataClass.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 11/17/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import Foundation
import CoreData


public class User: NSManagedObject {

    
    /* Add New User
        Creates a new user in the Model database based on info passed in. Does NOT check if the user already exists. Returns the new User object, or nil if there was an error.
        Does not add asked, answered Questions, or reviews
 
    */
//    class func addNewUser(id: Int, firstName: String, lastName: String, bio: String, credentials: String, inManagedObjectContext context: NSManagedObjectContext) -> User? {
//        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
//            user.id = Int32(id) //TODO: May want to pass in an Int32
//            user.firstName = firstName
//            user.lastName = lastName
//            user.bio = bio
//            user.credentials = credentials
//            
//            return user
//        }
//        
//        return nil
//    }
    
    class func getUser(id: Int, inManagedObjectContext context: NSManagedObjectContext) -> User? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //request.predicate = NSPredicate(format: "firstName == %@", "George")
        request.predicate = NSPredicate(format: "id == %i", id)
        
        if let user = (try? context.fetch(request))?.first as? User {
            return user
        }
        return nil
    }
    
    class func currentUser(inManagedObjectContext context: NSManagedObjectContext) -> User? {
        return getUser(id: 1, inManagedObjectContext: context) //NOTE: User ID is hardcoded here
    }
}
