//
//  GolferScoreTableViewCell.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-03.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class GolferScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var golferName: UILabel!
    @IBOutlet weak var numberOfStrokes: UIView!
    @IBOutlet weak var longestDriveSwitch: UISwitch!
    @IBOutlet weak var closestToPinSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
