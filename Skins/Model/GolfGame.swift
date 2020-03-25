//
//  GolfGame.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

struct GolfSummary {
    var totalStrokes: Int
    var totalSkins: Int
    
    init(_ strokes: Int, _ skins: Int) {
        totalStrokes = strokes
        totalSkins = skins
    }
}

protocol GolfGameCallback {
    func updateCurrentGame(game: GolfGame)
    func updateHole(hole: Hole)
    func updateAllHoles()
}

class GolfGame: NSObject, GolfGameCallback {
    var holes: [Hole] = []
    
    override init() {
    }
    
    init(names: [String]) {
        holes.append(Hole.init(holeNumber: 1, players: names))
    }
    
    // MARK: - Holes
    // Summarize all holes starting at holeNumber
    // If hole number is nil, then it will summarize all holes
    func summarizeHoles(_ holeNumber: Int?, startNextGame: Bool) {
        var prevHole: Hole?
        if (holeNumber ?? 1 != 1) {
            prevHole = holes[holeNumber! - 2]
        }
        
        for i in ((holeNumber ?? 1) - 1)..<holes.count {
            let hole = holes[i]
            
            if (prevHole != nil && prevHole!.shouldCarryOver()) {
                hole.carryOverSkins = prevHole!.carryOverSkins + 1
            }
            else {
                hole.carryOverSkins = 0
            }
            
            hole.awardSkins()
            prevHole = hole
        }
        
        if (startNextGame) {
            self.startNextHole()
        }
    }
    
    func startNextHole() {
        let nextHole = Hole(holeNumber: holes.count + 1, players: holes.last!.getListOfPlayers())
        
        if (holes.last?.shouldCarryOver() ?? false) {
            nextHole.carryOverSkins = holes.last!.carryOverSkins + 1
        }
        
        holes.append(nextHole)
    }
    
//    private func awardSkins(_ hole: Hole, winner: PlayerScore?) {
//        for golfer in hole.golfers {
//            golfer.awardSkins(par: hole.par, wonHole: golfer == winner, hole.carryOverSkins)
//        }
//    }
    
    func addNextHole() {
        if (holes.first != nil) {
            holes.append(Hole.init(holeNumber: holes.last!.holeNumber + 1, players: holes.last!.getListOfPlayers()))
        }
    }
    
    func getTotals(_ golfer: Int) -> GolfSummary {
        var strokes = 0
        var skins = 0
        
        for hole in holes {
            strokes += hole.golfers[golfer].strokes
            skins += hole.golfers[golfer].skins
        }
        
        return GolfSummary(strokes, skins)
    }
    
    // MARK: - GolfGameCallback
    func updateCurrentGame(game: GolfGame) {
        holes = game.holes
    }
    
    func updateHole(hole: Hole) {
        let index = hole.holeNumber
        holes[index-1] = hole
        summarizeHoles(hole.holeNumber, startNextGame: false)
    }
    
    func updateAllHoles() {
        summarizeHoles(nil, startNextGame: false)
    }
}
