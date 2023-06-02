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
    
    func writeNewGame(game: GolfGame) {
        if (appDelegate.user?.isSignedIn() ?? false) {
            do {
                // golf-stats/user_id/games/game_id/...
                try appDelegate.firebase!.db.collection(FirebaseHelper.collection)
                    .document(appDelegate.user!.uid)
                    .collection(FirebaseHelper.gameCollection)
                    .addDocument(from: game)
                    .setData(from: game)
            } catch let error {
                print("Error writing the game - \(error.localizedDescription)")
            }
        }
    }
    
    func loadLastTenGames(completion: @escaping (Array<GolfGame>?, Error?) -> Void) {
        print("Loading last 10? \(appDelegate.user?.isSignedIn() ?? false)")
        if (appDelegate.user?.isSignedIn() ?? false) {
            if (prevGames.count < 10) {
                let docRef = appDelegate.firebase!.db.collection(FirebaseHelper.collection)
                    .document(appDelegate.user!.uid)
                    .collection(FirebaseHelper.gameCollection)
                    .limit(to: 10)
                
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
        }
    }
    
}
