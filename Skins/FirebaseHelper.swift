//
//  FirebaseHelper.swift
//  Skins
//
//  Created by Logan Kember on 2020-06-07.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit
import Firebase

struct TinyUser {
    var displayName: String
    var email: String
    var id: String
    
    init(_ data: [String: Any], id: String) {
        self.displayName = data["displayName"] as! String
        self.email = data["email"] as! String
        self.id = id
    }
}

class FirebaseHelper: NSObject {
    static let collection = "golf-stats"
    static let usersCollection = "Users"
    static let gameCollection = "Games"
    static let friendsList = "Friends"
    static let liveGame = "LiveGame"
    var db: Firestore!
    
    override init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func addUserToUsersCollection(user: User?) {
        if let user = user {
            db.collection(FirebaseHelper.usersCollection).document(user.uid).setData([
                "Email" : user.email as Any,
                "DisplayName" : user.displayName as Any
            ])
        }
    }
    
    func getUserForID(_ id: String) -> TinyUser? {
        var user: TinyUser?
        
        let docRef = db.collection(FirebaseHelper.usersCollection).document(id)
        
        docRef.getDocument(completion: { (document, error) in
            if let error = error {
                print("Error getting user: \(error)")
            }
            else {
                let data = document!.data()!
                user = TinyUser.init(data, id: id)
            }
        })
        
        return user
    }
}
