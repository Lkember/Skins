//
//  Stats.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-25.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit
import Firebase

protocol FirestoreConverter {
    func getFirestoreData() -> [String : Any]
}

struct Stats {
    
    // DB Info
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var prevGames: [GolfGame] = []
    
    func getLastTenGames() -> [GolfGame] {
        return self.prevGames
    }
    
    // MARK: - Data Write
    func writeNewGame(game: GolfGame) {
        if (appDelegate.user?.isSignedIn() ?? false) {
            do {
                // golf-stats/user_id/games/game_id/...
                try appDelegate.firebase!.db
                    .collection(FirebaseHelper.collection)
                    .document(appDelegate.user!.uid)
                    .collection(FirebaseHelper.gameCollection)
                    .addDocument(from: game)
                    .setData(from: game)
            } catch let error {
                print("Error writing the game - \(error.localizedDescription)")
            }
        }
    }
    
    func writeLiveGame(game: GolfGame) {
        if (appDelegate.user?.isSignedIn() ?? false) {
            do {
                try appDelegate.firebase!.db
                    .collection(FirebaseHelper.collection)
                    .document(appDelegate.user!.uid)
                    .collection(FirebaseHelper.liveGame)
                    .document(game.gameID!)
                    .setData(from: game, merge: true)
            } catch let error {
                print("Error writing the game - \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Data Deletion
    func eraseLiveGame(game: GolfGame) {
        if (appDelegate.user?.isSignedIn() ?? false) {
            appDelegate.firebase!.db
                .collection(FirebaseHelper.collection)
                .document(appDelegate.user!.uid)
                .collection(FirebaseHelper.liveGame)
                .document(game.gameID!)
                .delete()
        }
    }
    
    // MARK: - Data Read
    func loadLastTenGames(completion: @escaping (Array<GolfGame>?, Error?) -> Void) {
        print("Loading last 10? \(appDelegate.user?.isSignedIn() ?? false)")
        if (appDelegate.user?.isSignedIn() ?? false) {
            if (prevGames.count < 10) {
                let docRef = appDelegate.firebase!.db
                    .collection(FirebaseHelper.collection)
                    .document(appDelegate.user!.uid)
                    .collection(FirebaseHelper.gameCollection)
                    .limit(to: 10)
                    .order(by: "date", descending: true)
                
                var games: [GolfGame] = []
                
                docRef.getDocuments() { (querySnapshot, err) in
                    DispatchQueue.main.async() {
                        if let err = err {
                            print("Error getting documents: \(err)")
                            completion(nil, err)
                        }
                        
                        do {
                            for doc in querySnapshot!.documents {
                                let game = try doc.data(as: GolfGame.self)
                                games.append(game)
                            }
                            print("Games updated \(games)")
                            appDelegate.user!.updatePrevGames(prevGames: games)
                            completion(games, nil)
                        } catch let err {
                            print("error converting to golf game - \(err)")
                            completion(nil, err)
                        }
                    }
                }
            }
            completion(nil, nil)
        }
    }
    
    
    func loadLiveGame(completion: @escaping (GolfGame?, Error?) -> Void) {
        print("Loading live game? \(appDelegate.user?.isSignedIn() ?? false)")
        if (appDelegate.user?.isSignedIn() ?? false) {
            let docRef = appDelegate.firebase!.db
                .collection(FirebaseHelper.collection)
                .document(appDelegate.user!.uid)
                .collection(FirebaseHelper.liveGame)
            
            docRef.getDocuments() { (querySnapshot, err) in
                DispatchQueue.main.async() {
                    if let err = err {
                        print("Error getting documents: \(err)")
                        completion(nil, err)
                    }
                    
                    do {
                        if (querySnapshot!.documents.count == 0) {
                            print("No live game found")
                            completion(nil, nil)
                            return
                        }
                        
                        let doc = querySnapshot!.documents[0]
                        let game = try doc.data(as: GolfGame.self)
                        game.gameID = doc.documentID
                        
                        print("live game retrieved - \(game)")
                        
                        completion(game, nil)
                        
                    } catch let err {
                        print("error getting live game - \(err)")
                        completion(nil, err)
                    }
                }
            }
        }
    }
    
}
