//
//  InvitedGolferTableViewCell.swift
//  Skins
//
//  Created by Logan Kember on 2020-05-25.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class InvitedGolferTableViewCell: UITableViewCell, NewGolferCell {
    
    var player: Player?
    
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
    
    private func updateAsUser() {
        inviteActivityIndicator.isHidden = true
        uninviteUserButton.isHidden = true
    }
    
    func setGolfer(name: String, uid: String?) {
        self.player = Player(uid: uid, name: name)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.golferNameLabel.text = name
        
        // If this is the user, then remove the uninvite button
        if (uid != nil && appDelegate.user?.uid == uid) {
            updateAsUser()
            
            self.golferNameLabel.text = "\(name) (you)"
        }
    }
    
    func getGolferName() -> String {
        return player?.name ?? ""
    }
    
    func getGolfer() -> Player {
        return player!
    }
    
}
