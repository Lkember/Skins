//
//  PendingFriendTableViewCell.swift
//  Skins
//
//  Created by Logan Kember on 2020-06-09.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class PendingFriendTableViewCell: UITableViewCell {

    var id: String?
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Initialization
    func initialize(id: String, name: String, email: String) {
        self.id = id
        displayNameLabel.text = name
        emailLabel.text = name
    }
    
    // MARK: UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Buttons
    @IBAction func acceptRequestPressed(_ sender: Any) {
        
    }
    
    @IBAction func declineRequestPressed(_ sender: Any) {
        
    }
}
