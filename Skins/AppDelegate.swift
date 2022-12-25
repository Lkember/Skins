//
//  AppDelegate.swift
//  Skins
//
//  Created by Logan Kember on 2020-02-17.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseOAuthUI
import FirebaseGoogleAuthUI
//import FirebaseFacebookAuthUI
import FirebaseEmailAuthUI
import FirebaseDatabaseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FUIAuthDelegate {
    
    var signInPassback: SignInPassback?
    var window: UIWindow?
    var user: SkinsUser?
    var authUI: FUIAuth?
    var firebase: FirebaseHelper?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        user = SkinsUser()
        firebase = FirebaseHelper()
        
        // update current user's information if signed in
        if (user!.isSignedIn()) {
            firebase?.addUserToUsersCollection(user: user!.user)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - FUIAuthDelegate
    func presentUserWithLoginPrompt(vc: UIViewController) {
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        let providers: [FUIAuthProvider] = [
            
            FUIOAuth.microsoftAuthProvider(),
            FUIGoogleAuth(),
            FUIEmailAuth(),
//            FUIFacebookAuth()
        ]
        
        authUI?.providers = providers
        
        if let authViewController = authUI?.authViewController() {
            vc.present(authViewController, animated: true, completion: { self.firebase!.addUserToUsersCollection(user: self.user!.user) })
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
      // handle user and error as necessary
        if (error == nil) {
            if (user != nil) {
                self.user!.updateUser(user: user!)
                self.signInPassback?.userSignedIn()
            }
            else {
                print("User returned was nil")
            }
        }
        else {
            print("Error when signing in: \(error.debugDescription)")
        }
    }
}

