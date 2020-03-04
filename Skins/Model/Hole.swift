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
    var strokes: Int
    var longestDrive: Bool
    var closestToPin: Bool
    var par: Int
    
    override init() {
        holeNumber = 0
        strokes = 0
        par = 0
        longestDrive = false
        closestToPin = false
    }
    
    init(holeNumber: Int) {
        self.holeNumber = holeNumber
        strokes = 0
        par = 0
        longestDrive = false
        closestToPin = false
    }
    
    func updatePar(par: Int) {
        self.par = par
    }
}
