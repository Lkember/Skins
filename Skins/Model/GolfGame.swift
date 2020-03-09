//
//  GolfGame.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class GolfGame: NSObject {
    var holes: [Hole] = []
//    var golfers: [PlayerScore]
//    var currentHole = 1
//    var carryOverSkins: Int = 0
    
    override init() {
    }
    
    init(names: [String]) {
        holes.append(Hole.init(holeNumber: 1, players: names))
    }
    
    // MARK: - Holes
    // Used when modifying existing holes
    func summarizeAllHoles() {
        for hole in holes {
            summarizeHole(hole: hole, startNextGame: false)
        }
    }
    
    // Used to summarize a specific hole
    func summarizeHole(hole: Hole, startNextGame: Bool) {
        var carryOver = false
        
        // Summarize hole and create next one
        let sortedScores = hole.golfers.sorted(by: {$0.strokes < $1.strokes})
        if (sortedScores.count > 1) {
            if (sortedScores[0].strokes < sortedScores[1].strokes) {
                awardSkins(hole, winner: sortedScores[0])
            }
            else {
                carryOver = true
                awardSkins(hole, winner: nil)
            }
        }

        if (startNextGame) {
            self.startNextHole(carryOver)
        }
    }
    
    func startNextHole(_ carryOver: Bool) {
        let nextHole = Hole(holeNumber: holes.count + 1, players: holes.last!.getListOfPlayers())
        nextHole.carryOverSkins = holes.last?.carryOverSkins ?? 0
        
        if (carryOver) {
            nextHole.carryOverSkins += 1
        }
        
        holes.append(nextHole)
    }
    
    private func awardSkins(_ hole: Hole, winner: PlayerScore?) {
        for golfer in hole.golfers {
            golfer.awardSkins(par: hole.par, wonHole: golfer == winner)
        }
    }
    
    func addNextHole() {
        if (holes.first != nil) {
            holes.append(Hole.init(holeNumber: holes.last!.holeNumber + 1, players: holes.last!.getListOfPlayers()))
        }
    }
}
