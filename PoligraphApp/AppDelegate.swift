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
        UIApplication.shared.statusBarStyle = .lightContent
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.tintColor = uicolorFromHex(rgbValue: 0xffffff)
        navigationBarAppearance.barTintColor = UIColor.polyBlue()
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        UISearchBar.appearance().barTintColor = UIColor.polyBlue()
        UISearchBar.appearance().tintColor = UIColor.white
        UISearchBar.appearance().placeholder = "Ask Poligraph"
        fetchLocalItems(errorPrint)
        Question.printAllQuestions(inManagedObjectContext: self.dataStack.mainContext)
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
    
    /* Error Handler for fetchLocalItems */
    func errorPrint(error: NSError?) {
        if let error = error {
            print("Error \(error)")
        }
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
}

extension UIColor {
    static func polyBlue() -> UIColor {
        return UIColor(red: 45.0/255.0, green: 156.0/255.0, blue: 219.0/255.0, alpha: 1.0)
    }
}


