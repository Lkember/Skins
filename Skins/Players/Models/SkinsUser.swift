//
//  SkinsUser.swift
//  Skins
//
//  Created by Logan Kember on 2020-04-10.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit
import FirebaseAuth

class SkinsUser: NSObject {

    var uid: String
    var displayName: String?
    var email: String?
    var stats = Stats()
    
    init(user: User) {
        self.uid = user.uid
        self.displayName = user.displayName
        self.email = user.email
    }

    func isSignedIn() -> Bool {
        if (Auth.auth().currentUser == nil) {
            return false
        }
        return true
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch let err {
            print("Error signing out: \(err.localizedDescription)")
        }
    }
    
    func updatePrevGames(prevGames: [GolfGame]) {
        self.stats.prevGames = prevGames
    }
    
    func loadLastTenGames(completion: @escaping (Array<GolfGame>?, Error?) -> Void) {
        stats.loadLastTenGames(completion: completion)
    }
}
