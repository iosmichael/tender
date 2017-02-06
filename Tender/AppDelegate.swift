//
//  AppDelegate.swift
//  Tender
//
//  Created by Michael Liu on 1/23/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{

    override init() {
        super.init()
        // Firebase Init
        FIRApp.configure()
    }
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        // Override point for customization after application launch.
        return true
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                        sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                        annotation: [:])
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                    sourceApplication: sourceApplication,
                                    annotation: annotation)
    }

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if let error = error {
            print(error.localizedDescription)
            return
        }
        UserDefaults.standard.setValue(user.userID, forKey: "uid")
        UserDefaults.standard.setValue(user.profile.email, forKey: "email")
        UserDefaults.standard.setValue(user.profile.imageURL(withDimension: 200).absoluteString, forKey: "thumbnail")
        UserDefaults.standard.setValue(user.profile.name, forKey: "name")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginNotification"), object: nil)
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                          accessToken: (authentication?.accessToken)!)
        let userData = ["email":user.profile.email,
                        "thumbnail":user.profile.imageURL(withDimension: 200).absoluteString,
                        "name":user.profile.name]
        FIRDatabase.database().reference().child("users/\(user.userID!)").setValue(userData)
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        })
        
    }

    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        let current = FIRAuth.auth()
        do{
            try current?.signOut()
            UserDefaults.standard.setValue(nil, forKey: "uid")
            UserDefaults.standard.setValue(nil, forKey: "email")
            UserDefaults.standard.setValue(nil, forKey: "thumbnail")
            UserDefaults.standard.setValue(nil, forKey: "name")
        }catch let signOutError as NSError{
            print("Error signing out: %@",signOutError)
        }
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

}

