//
//  AppDelegate.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/13/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit
import CoreData
import DATAStack
import Sync

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        fetchLocalItems(errorPrint)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    // MARK: - Core Data stack
    
    let dataStack = DATAStack(modelName:"Model")
    
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//         */
////        let container = NSPersistentContainer(name: "PoligraphApp")
//        let container = DATAStack(modelName: "PoligraphApp")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
    
    // MARK: - Core Data Preloading
    
    
    func fetchLocalItems(_ completion: @escaping (NSError?) -> Void) {
        let url = URL(string: "test.json")!
        let filePath = Bundle.main.path(forResource: url.deletingPathExtension().absoluteString, ofType: url.pathExtension)!
        let data = try! Foundation.Data(contentsOf: URL(fileURLWithPath: filePath))
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
        self.dataStack.performInNewBackgroundContext { backgroundContext in
            
            Sync.changes(json["users"] as! Array, inEntityNamed: "User", predicate: nil, parent: nil, inContext: backgroundContext, dataStack: self.dataStack, completion: { error in
                NotificationCenter.default.removeObserver(self, name: .NSManagedObjectContextObjectsDidChange, object: nil)
                completion(error)
            })
        }
        print("Local Items Fetched")
    }
    
    func errorPrint(error: NSError?) {
        if let error = error {
            print("Error \(error)")
        }
    }
    
    
//    func preloadData() {
//        // TODO: Implement Preload
//        
//        //Test code with one user, one question
//        //let context = self.dataStack.mainContext
//        //JSONSerialization.jsonObject(with: dataOK, options: []) as? [String: AnyObject]
//        
//        if let path = Bundle.main.path(forResource: "test", ofType: "json")
//        {
//            if let jsonData = NSData(contentsOfFile: path)
//            {
////                if let jsonResult = try! JSONSerialization.JSONObjectWithData(jsonData, options: JSONSerialization.ReadingOptions.MutableContainers) as? [[String: Any]]
//                
//                if let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject]
//                {
//                    Sync.changes(
//                        jsonResult,
//                        inEntityNamed: "User",
//                        dataStack: dataStack) { error in
//                            // New objects have been inserted
//                            // Existing objects have been updated
//                            // And not found objects have been deleted
//                    }
//                    print("Sync Completed")
//                }
//            }
//        }
    

        //TODO: Clear database?
        
        // Parse JSON (or CSV)
        
        //First, load users
            //User.addNewUser(id: <#T##Int#>, firstName: <#T##String#>, lastName: <#T##String#>, bio: <#T##String#>, credentials: <#T##String#>, inManagedObjectContext: context)
        
        //Second, load questions
            //Question.addQuestion(asker: <#T##User#>, text: <#T##String#>, inManagedObjectContext: context)
            //Add other attributes for answered questions
        
            //TODO: make sure that these reciprocate to users
        
        //Third, load reviews
            //Review.addNewReview(feedbackText: <#T##String#>, recommendation: <#T##Int#>, biasRating: <#T##Double#>, question: <#T##Question#>, reviewer: <#T##User#>, inManagedObjectContext: context)
        
            //TODO: Make sure that reviews reciprocate to questions and users
        
        //Save
//        do {
//            try context.save()
//            print("Data successfully preloaded")
//        } catch let error as NSError {
//            print("Could not save database on preload: \(error), \(error.userInfo)")
//        }
 //   }
    

    // MARK: - Core Data Saving support
    
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    

    


    

}

