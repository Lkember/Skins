//
//  GolfGame.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class GolfGame: NSObject {
    var golfers: [PlayerScore]
    
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
    
    
}
