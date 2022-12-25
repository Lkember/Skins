//
//  PlayerScore.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class PlayerScore: NSObject, FirestoreConverter {
    var playerName: String
    var strokes: Int
    var skins: Int
    var extraSkin: Bool     // longest drive or closest to pin
    
    override init() {
        playerName = ""
        strokes = 0
        skins = 0
        extraSkin = false
        super.init()
    }
    
    init(name: String) {
        playerName = name
        strokes = 0
        skins = 0
        extraSkin = false
        super.init()
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
            "playerName" : playerName,
            "strokes" : strokes,
            "skins" : skins,
            "extraSkin" : extraSkin
        ]
    }
}
