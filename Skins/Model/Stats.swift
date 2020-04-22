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

class Stats: NSObject {
    
    // DB Info
    static let collection = "golf-stats"
    static let gameCollection = "Games"
    var dbRef: Firestore!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var prevGames: [GolfGame] = []
    
    override init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        dbRef = Firestore.firestore()
    }
    
    func writeNewGame(game: GolfGame) {
        prevGames.append(game)
        
        if (appDelegate.user!.isSignedIn()) {
            
            // golf-stats/emailaddress/games/date/(game data)
            dbRef.collection(Stats.collection)
                .document(appDelegate.user!.user!.email!)
                .collection(Stats.gameCollection)
                .document("\(game.date)")
                .setData(game.getFirestoreData())
            
            // If the games are being backed up to the DB, then only store the last 10 on the device
            if (prevGames.count > 10) {
                prevGames.remove(at: 0)
            }
        }
    }
    
}
