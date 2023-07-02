//
//  HomeTabViewController.swift
//  Skins
//
//  Created by Logan Kember on 2023-01-07.
//  Copyright © 2023 Logan Kember. All rights reserved.
//

import Foundation
import UIKit

class HomeTabViewController: UITabBarController, SignInPassback, GolfGameCallback {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var liveGame: GolfGame?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storyboard?.instantiateViewController(withIdentifier: "StatsViewController")
        
        loadLiveGame()
        
        if (appDelegate.user == nil) {
            appDelegate.signInPassback = self
            appDelegate.presentUserWithLoginPrompt(vc: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTabBar()
    }
    
    func loadLiveGame() {
        if (liveGame == nil) {
            appDelegate.user?.stats.loadLiveGame() { (result, error) in
                self.liveGameLoaded(result: result, error: error)
            }
        }
    }
    
    func updateTabBar() {
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
                self.storyboard!.instantiateViewController(withIdentifier: "HoleScoreHelperViewController"),
                self.storyboard!.instantiateViewController(withIdentifier: "FriendsListTableViewController"),
                self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController")
            ], animated: true)
        }
    }
    
    
    // MARK: - SignInPassback
    func userSignedIn() {
        // Nothing to do
    }
    
    // MARK: - GolfGameCallback
    func createNewGame(golfers: [Player]) {
        print("new game created")
        liveGame = GolfGame(players: golfers)
        self.updateTabBar()
        
        // Write the game to firestore
        self.appDelegate.user?.stats.writeLiveGame(game: liveGame!)
    }
    
    func getLiveGame() -> GolfGame? {
        return self.liveGame
    }
    
    func endGame() {
        if (liveGame != nil) {
            print("Ending game \(String(describing: liveGame!.gameID))")
            liveGame!.summarizeHoles()
            appDelegate.user!.stats.writeNewGame(game: liveGame!)
            appDelegate.user!.stats.eraseLiveGame(game: liveGame!)
            
            // Add the game to the list of previous games to avoid query to DB
            self.appDelegate.user?.stats.prevGames.insert(self.liveGame!, at: 0)
            
            self.liveGame = nil
        }
        
        // Go to the stats view
        self.selectedIndex = 0
        
        // Update tabs
        self.updateTabBar()
    }
    
    func updateCurrentGame(game: GolfGame) {
        liveGame = game
    }
    
    func holeDidChange(hole: Int) {
        if (liveGame != nil) {
            liveGame!.holeDidChange(holeNumber: hole)
            
            // Update in Firestore
            appDelegate.user?.stats.writeLiveGame(game: liveGame!)
        }
    }
    
    func startNextHole() {
        if (liveGame != nil) {
            liveGame!.startNextHole()
            
            // Update in Firestore
            appDelegate.user?.stats.writeLiveGame(game: liveGame!)
        }
    }
    
    // MARK: - Live Game Retrieval Completion
    func liveGameLoaded(result: GolfGame?, error: Error?) {
        if (error != nil) {
            // TODO - Handle Error
            print("Error retrieving data")
        }
        
        if (result != nil) {
            print("Live game loaded \(String(describing: result!.gameID))")
            self.liveGame = result
            self.updateTabBar()
        }
    }
    
}
