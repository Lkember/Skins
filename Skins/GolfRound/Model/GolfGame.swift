//
//  GolfGame.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift

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

class GolfGame: NSObject, GolfGameCallback, FirestoreConverter, Codable {
    @DocumentID var gameID: String?
    var holes: [Hole] = []
    var date: Date
    
    override init() {
        date = Date()
    }
    
    init(names: [String]) {
        holes.append(Hole.init(holeNumber: 1, players: names))
        date = Date()
        print("holes.count = \(holes.count)")
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
        print("\(holes.count)")
        let nextHole = Hole(holeNumber: holes.count + 1, players: holes.last!.getListOfPlayers())
        
        if (holes.last?.shouldCarryOver() ?? false) {
            nextHole.carryOverSkins = holes.last!.carryOverSkins + 1
        }
        
        holes.append(nextHole)
    }
    
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
    
    // MARK: - FirestoreConverter
    func getFirestoreData() -> [String : Any] {
        var fsData : [String : Any] = [
            "date" : date
        ]
        
        for hole in holes {
            fsData["\(hole.holeNumber)"] = hole.getFirestoreData()
        }
        
        return fsData
    }
}
