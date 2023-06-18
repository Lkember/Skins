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
    var liveGame: GolfGame? { get set }
    
    func createNewGame(golfers: [Player])
    func updateCurrentGame(game: GolfGame)
    func updateHoles(startNextHole: Bool)
    func endGame()
}

class GolfGame: NSObject, FirestoreConverter, Codable {
    @DocumentID var gameID: String?
    var holes: [Hole] = []
    var players: [Player] = []
    var date: Date
    
    override init() {
        date = Date()
    }
    
    init(players: [Player]) {
        self.players = players
        holes.append(Hole.init(holeNumber: 1, players: players))
        date = Date()
    }
    
    // MARK: - Holes
    // Summarize all holes
    func summarizeHoles(startNextHole: Bool) {
        for i in 0..<holes.count {
            let hole = holes[i]
            if (i == 0) {
                hole.carryOverSkins = 0
            }
            else if (i != 0 && holes[i-1].shouldSkinCarryOver()) {
                hole.carryOverSkins = holes[i-1].carryOverSkins + 1
            }
            
            hole.awardSkinsForHole()
        }
        
        if (startNextHole) {
            self.startNextHole()
        }
    }
    
    func startNextHole() {
        let nextHole = Hole(holeNumber: holes.count + 1, players: self.players)
        
        if (holes.last?.shouldSkinCarryOver() ?? false) {
            nextHole.carryOverSkins = holes.last!.carryOverSkins + 1
        }
        
        holes.append(nextHole)
    }
    
    func addNextHole() {
        if (holes.first != nil) {
            holes.append(
                Hole.init(holeNumber: holes.last!.holeNumber + 1, players: self.players)
            )
        }
    }
    
    func getTotalsForGolfer(_ golfer: Player) -> GolfSummary {
        var strokes = 0
        var skins = 0

        for hole in holes {
            strokes += hole.golfers[golfer.uid]!.strokes
            skins += hole.golfers[golfer.uid]!.skins
        }

        return GolfSummary(strokes, skins)
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
