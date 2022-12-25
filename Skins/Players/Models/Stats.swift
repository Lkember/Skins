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

//struct Result {
//    var error: Error
//    var game: GolfGame?
//}

class Stats: NSObject {
    
    // DB Info
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var prevGames: [GolfGame] = []
    
    func writeNewGame(game: GolfGame) {
        prevGames.append(game)
        
        if (appDelegate.user!.isSignedIn()) {
            
            // golf-stats/emailaddress/games/date/(game data)
            appDelegate.firebase!.db.collection(FirebaseHelper.collection)
                .document(appDelegate.user!.user!.uid)
                .collection(FirebaseHelper.gameCollection)
                .document("\(game.date)")
                .setData(game.getFirestoreData())
            
            // If the games are being backed up to the DB, then only store the last 10 on the device
            if (prevGames.count > 10) {
                prevGames.remove(at: 0)
            }
        }
    }
    
    func loadLastTenGames() {
        if (appDelegate.user!.isSignedIn()) {
            if (prevGames.count < 10) {
                let docRef = appDelegate.firebase!.db.collection(FirebaseHelper.collection)
                    .document(appDelegate.user!.user!.uid)
                    .collection(FirebaseHelper.gameCollection)
                    .limit(to: 10)
                docRef.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        return
                    }
                    
    //                var results: [Result] = []
                    for doc in querySnapshot!.documents {
                        print("\(doc.documentID) => \(doc.data())")
                    }
                }
            }
        }
    }
    
}
