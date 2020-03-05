//
//  GolfGame.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

//struct HoleSummary {
//    var hole: Hole
//    var index: Int
//}

class GolfGame: NSObject {
    var golfers: [PlayerScore]
    var currentHole = 1
    var carryOverSkins: Int = 0
    
    override init() {
        golfers = []
    }
    
    init(names: [String]) {
        golfers = []
        
        for name in names {
            let newPlayer = PlayerScore.init(name: name)
            golfers.append(newPlayer)
        }
    }
    
    func summarizeHole(startNextGame: Bool) {
        currentHole += 1
        
        // Summarize hole and create next one
        var holes: [Hole] = []
        for i in 0..<golfers.count {
            if (golfers[i].holes.count > 0) {
//                let summary = HoleSummary.init(hole: golfers[i].holes.last!, index: i)
//                holes.append(summary)
                holes.append(golfers[i].holes.last!)
            }
            
            if (startNextGame) {
                golfers[i].createNextHole(currentHole)
            }
        }
        
        awardSkins(holes)
    }
    
    func awardSkins(_ hole: [Hole]) {
        // Update skins for hole
        var hole = hole
        
        for h in hole {
            h.awardSkins()
        }
        
        hole = hole.sorted(by: {$0.strokes < $1.strokes})
        if (hole.count > 1 && hole[0].strokes < hole[1].strokes /*&& hole[0].strokes <= hole[0].par*/) {
            
            // Updates skins for winner of hole
            hole[0].wonHole(carryOverSkins)
            carryOverSkins = 0
        }
        else {
            carryOverSkins += 1
        }
    }
}
