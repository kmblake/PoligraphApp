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
    
    class func getUser(id: Int, inManagedObjectContext context: NSManagedObjectContext) -> User? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
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
