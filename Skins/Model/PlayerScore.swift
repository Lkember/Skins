//
//  PlayerScore.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class PlayerScore: NSObject {
    var playerName: String
    var strokes: Int
    var skins: Int
    var longestDrive: Bool
    var closestToPin: Bool
    
    override init() {
        playerName = ""
        strokes = 0
        skins = 0
        longestDrive = false
        closestToPin = false
        super.init()
    }
    
    init(name: String) {
        playerName = name
        strokes = 0
        skins = 0
        longestDrive = false
        closestToPin = false
        super.init()
    }
    
    func awardSkins(par: Int, wonHole: Bool) {
        skins = 0
        
        if (strokes <= par) {
            if (longestDrive) {
                skins += 1
            }
            if (closestToPin) {
                skins += 1
            }
        }
        
        if (wonHole) {
            skins += 1
        }
    }
}
