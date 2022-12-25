//
//  Hole.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class Hole: NSObject, FirestoreConverter {
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
    
    func shouldCarryOver() -> Bool {
        let scores = golfers.sorted(by: {$0.strokes < $1.strokes})
        
        if (scores.count == 1 || scores[0].strokes < scores[1].strokes) {
            return false
        }
        
        return true
    }
    
    func awardSkins() {
        let scores = golfers.sorted(by: {$0.strokes < $1.strokes})
        var winner: PlayerScore?
        
        if (golfers.count == 1 || scores[0].strokes < scores[1].strokes) {
            winner = scores[0]
        }
        
        for golfer in golfers {
            golfer.awardSkins(par: par, wonHole: golfer == winner, carryOverSkins)
        }
    }
    
    // MARK: - FirestoreConverter
    func getFirestoreData() -> [String : Any] {
        var fsData : [String : Any] =
        [
            "holeNumber" : holeNumber,
            "par" : par,
            "carryOverSkins" : carryOverSkins
        ]

        for golfer in golfers {
            fsData[golfer.playerName] = golfer.getFirestoreData()
        }
        
        return fsData
    }
}
