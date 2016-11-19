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
    class func addNewUser(id: Int, firstName: String, lastName: String, bio: String, credentials: String, inManagedObjectContext context: NSManagedObjectContext) -> User? {
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.id = Int32(id) //TODO: May want to pass in an Int32
            user.firstName = firstName
            user.lastName = lastName
            user.bio = bio
            user.credentials = credentials
            
            return user
        }
        
        return nil
    }
}
