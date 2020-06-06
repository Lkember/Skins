//
//  InvitedGolferTableViewCell.swift
//  Skins
//
//  Created by Logan Kember on 2020-05-25.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class InvitedGolferTableViewCell: UITableViewCell, NewGolferCell {
    var golferName: String = ""
    @IBOutlet weak var inviteActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var golferNameLabel: UILabel!
    @IBOutlet weak var uninviteUserButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func uninviteUserButton(_ sender: Any) {
        // TODO
    }
    
    func updateAsUser() {
        inviteActivityIndicator.isHidden = true
        uninviteUserButton.isHidden = true
    }
    
    func setGolferName(_ name: String) {
        golferNameLabel.text = name
    }
    
    func getGolferName() -> String {
        return golferNameLabel.text ?? ""
    }
    
}
