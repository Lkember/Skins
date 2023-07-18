//
//  Hole.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class Hole: NSObject, FirestoreConverter, Codable {
    
    var holeNumber: Int
    var par: Int = 0
    var carryOverSkins: Int = 0
    var golfers: [String : PlayerScore] = [:]
    
    override init() {
        holeNumber = 1
        par = 0
    }
    
    init(holeNumber: Int, players: [Player]) {
        self.holeNumber = holeNumber
        
        for player in players {
            golfers[player.uid] = PlayerScore(uid: player.uid)
        }
        par = 4
    }
    
    func updatePar(par: Int) {
        self.par = par
    }
    
    func shouldSkinCarryOver() -> Bool {
        var lowScore = Int.max
        var lsCount = 0
        
        for key in golfers.keys {
            let player = golfers[key]!
            if (player.strokes < lowScore) {
                lowScore = player.strokes
                lsCount = 1
            }
            else if (player.strokes == lowScore) {
                lsCount += 1
            }
        }
        
        return lsCount > 1
    }
    
    func playerToWinHole() -> String? {
        var lowScore = Int.max
        var lsCount = 0
        var lowScorePlayer: PlayerScore? = nil
        
        for key in golfers.keys {
            let player = golfers[key]!
            if (player.strokes < lowScore) {
                lowScore = player.strokes
                lsCount = 1
                lowScorePlayer = player
            }
            else if (player.strokes == lowScore) {
                lsCount += 1
                lowScorePlayer = nil
            }
        }
        
        return lowScorePlayer?.uid
    }
    
    func awardSkinsForHole() {
        let winner = self.playerToWinHole()
        
        for key in golfers.keys {
            let pScore = golfers[key]!
            pScore.awardSkins(par: par, wonHole: winner == pScore.uid, carryOverSkins)
        }
    }
    
    // MARK: - FirestoreConverter
    func getFirestoreData() -> [String : Any] {
//        var fsData : [String : Any] =
//        [
//            "holeNumber" : holeNumber,
//            "par" : par,
//            "carryOverSkins" : carryOverSkins
//        ]
//
//        for golfer in golfers {
//            fsData[golfer.playerName] = golfer.getFirestoreData()
//        }
//
//        return fsData
        return [:]
    }
    
    
}
