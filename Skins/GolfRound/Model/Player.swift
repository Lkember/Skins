//
//  Player.swift
//  Skins
//
//  Created by Logan Kember on 2023-06-03.
//  Copyright © 2023 Logan Kember. All rights reserved.
//

import Foundation

class Player: NSObject, Codable {
    var uid: String
    var name: String
    
    init(uid: String?, name: String) {
        self.uid = uid == nil ? UUID.init().uuidString : uid!
        self.name = name
    }
}
