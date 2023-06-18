//
//  PlayerScore.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class PlayerScore: NSObject, FirestoreConverter, Codable {
    var uid: String
    var strokes: Int
    var skins: Int
    var extraSkin: Bool     // longest drive or closest to pin
    
    init(uid: String) {
        self.uid = uid
        strokes = 0
        skins = 0
        extraSkin = false
        super.init()
    }
    
    required init(uid: String, strokes: Int, skins: Int, extraSkin: Bool) {
        self.uid = uid
        self.strokes = strokes
        self.skins = skins
        self.extraSkin = extraSkin
    }
    
    func awardSkins(par: Int, wonHole: Bool, _ carryOverSkins: Int) {
        skins = 0
        
        if (strokes <= par) {
            if (extraSkin) {
                skins += 1
            }
        }
        
        if (wonHole) {
            skins += carryOverSkins
            skins += 1
        }
    }
    
    // MARK: - FirestoreConverter
    func getFirestoreData() -> [String : Any] {
        return [
            "uid" : uid,
            "strokes" : strokes,
            "skins" : skins,
            "extraSkin" : extraSkin
        ]
    }
    
    // Converts firestore data to a player score object
    func convertFirestoreToSelf(firestoreData: [String : Any]) -> Self {
        return Self.init(
            uid: firestoreData["uid"] as! String,
            strokes: firestoreData["strokes"] as! Int,
            skins: firestoreData["skins"] as! Int,
            extraSkin: firestoreData["extraSkin"] as! Bool
        )
    }
}
