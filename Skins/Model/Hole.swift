//
//  Hole.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class Hole: NSObject {
    var holeNumber: Int
    var par: Int = 0
    var carryOverSkins: Int = 0
    var golfers: [PlayerScore] = []
    
    override init() {
        holeNumber = 1
        par = 0
    }
    
    init(holeNumber: Int, players: [String]) {
        self.holeNumber = holeNumber
        for player in players {
            golfers.append(PlayerScore.init(name: player))
        }
        par = 4
    }
    
//    init(holeNumber: Int) {
//        self.holeNumber = holeNumber
//        par = 4
//    }
    
    func updatePar(par: Int) {
        self.par = par
    }
    
    func getListOfPlayers() -> [String] {
        var output: [String] = []
        
        for golfer in golfers {
            output.append(golfer.playerName)
        }
        
        return output
    }
}
