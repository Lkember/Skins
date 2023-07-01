//
//  AddNewPlayerTableViewCell.swift
//  Skins
//
//  Created by Logan Kember on 2023-06-19.
//  Copyright © 2023 Logan Kember. All rights reserved.
//

import UIKit

class AddNewPlayerTableViewCell: UITableViewCell {
    
    var golfGameCreationHelper: GolfGameCreationHelper?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    @IBAction func addPlayerButtonPressed(_ sender: Any) {
        if (golfGameCreationHelper != nil) {
            golfGameCreationHelper?.addNewGolfer()
        }
    }
}
