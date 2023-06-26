//
//  NewGolferTableViewCell.swift
//  Skins
//
//  Created by Logan Kember on 2020-02-29.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

protocol NewGolferCell: UITableViewCell {
    func getGolfer() -> Player
}

class NewGolferTableViewCell: UITableViewCell, NewGolferCell {
    
    @IBOutlet weak var golferLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setGolferNumber(_ num: Int) {
        golferLabel.text = "Player #\(num)"
    }
    
    func getGolfer() -> Player {
        return Player(uid: nil, name: nameField.text ?? "Player")
    }
}
