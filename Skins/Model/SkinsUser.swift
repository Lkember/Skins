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
    var user: User?
    var stats = Stats()
    
    override init() {
        super.init()
        
        getCurrentUser()
    }
    
    init(user: User?) {
        self.user = user
    }
    
    func updateUser(user: User) {
        self.user = user
    }
    
    func isSignedIn() -> Bool {
        if (Auth.auth().currentUser == nil) {
            return false
        }
        return true
    }
    
    func getCurrentUser() {
        if let tempUser = Auth.auth().currentUser {
            user = tempUser
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        }
        catch let err {
            print("Error signing out: \(err.localizedDescription)")
        }
    }
    
//    // MARK: - NSCoding
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("User")
//
//    struct PropertyKey {
//        static let userKey = "user"
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(user, forKey: PropertyKey.userKey)
//    }
//
//    required convenience init?(coder: NSCoder) {
//        let user = coder.decodeObject(forKey: PropertyKey.userKey) as! User?
//        self.init(user: user)
//    }
}
