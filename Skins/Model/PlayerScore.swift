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
    }
    
    init(name: String) {
        playerName = name
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
    
    func createNextHole() {
        let hole = Hole.init(holeNumber: holes.count + 1)
        holes.append(hole)
    }
}
