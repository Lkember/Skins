//
//  HomeTabViewController.swift
//  Skins
//
//  Created by Logan Kember on 2023-01-07.
//  Copyright © 2023 Logan Kember. All rights reserved.
//

import Foundation
import UIKit

class HomeTabViewController: UITabBarController, SignInPassback, GameCallback {
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var liveGame: GolfGame?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Only show the live game tab if we have a live game
        if (liveGame == nil) {
            self.setViewControllers([
                self.storyboard!.instantiateViewController(withIdentifier: "StatsViewController"),
                self.storyboard!.instantiateViewController(withIdentifier: "NewGameViewController"),
                self.storyboard!.instantiateViewController(withIdentifier: "FriendsListTableViewController"),
                self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController")
            ], animated: false)
        }
        else {
            self.setViewControllers([
                self.storyboard!.instantiateViewController(withIdentifier: "StatsViewController"),
                self.storyboard!.instantiateViewController(withIdentifier: "NewGameViewController"),
                self.storyboard!.instantiateViewController(withIdentifier: "HoleScoreHelperViewController"),
                self.storyboard!.instantiateViewController(withIdentifier: "FriendsListTableViewController"),
                self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController")
            ], animated: true)
        }
        self.storyboard?.instantiateViewController(withIdentifier: "StatsViewController")
        
        if (appDelegate.user == nil) {
            appDelegate.signInPassback = self
            appDelegate.presentUserWithLoginPrompt(vc: self)
        }
    }
    
    
    // MARK: - SignInPassback
    func userSignedIn() {
        // Nothing to do
        
    }
    
    // MARK: - GameCallback
    func createNewGame(golfers: [String]) {
        print("new game created")
        liveGame = GolfGame.init(names: golfers)
        self.viewDidLoad()
    }
    
    func gameIsFinished() {
        liveGame = nil
    }
    
    func getLiveGame() -> GolfGame? {
        return self.liveGame
    }
}
