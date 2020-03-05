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
    var holes: [Hole] = []
    
    override init() {
        playerName = ""
        super.init()
        
        self.createNextHole(1)
    }
    
    init(name: String) {
        playerName = name
        super.init()
        
        self.createNextHole(1)
    }
    
    func getStrokeCount() -> Int {
        var strokes = 0
        
        for hole in holes {
            strokes += hole.strokes
        }
        
        return strokes
    }
    
    func getSkinCount() -> Int {
        var skins = 0
        
        for hole in holes {
            if (hole.longestDrive) {
                skins += 1
            }
            if (hole.closestToPin) {
                skins += 1
            }
        }
        
        return skins
    }
    
    func createNextHole(_ holeNumber: Int) {
        let hole = Hole.init(holeNumber: holeNumber)
        holes.append(hole)
    }
    
//    func playerWonHole(_ holeNumber: Int) {
//        if (holeNumber < holes.count) {
//            holes[holeNumber-1].wonHole(<#T##carryOverSkins: Int##Int#>)
//        }
//        else {
//            print("\(#file) / \(#function) / ERROR hole doesn't exist")
//        }
//    }
}
