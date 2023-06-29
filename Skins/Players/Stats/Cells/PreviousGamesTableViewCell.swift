//
//  PreviousGamesTableViewCell.swift
//  Skins
//
//  Created by Logan Kember on 2023-05-30.
//  Copyright © 2023 Logan Kember. All rights reserved.
//

import UIKit

extension Date {
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) \(diff > 1 ? "secs" : "sec") ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) \(diff > 1 ? "mins" : "min") ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) \(diff > 1 ? "hours" : "hour") ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) \(diff > 1 ? "days" : "day") ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) \(diff > 1 ? "weeks" : "week") ago"
    }
}

class PreviousGamesTableViewCell: UITableViewCell {
    
    var game: GolfGame?
    @IBOutlet weak var timeSinceLabel: UILabel!
    @IBOutlet weak var numberOfHolesLabel: UILabel!
    @IBOutlet weak var youShotLabel: UILabel!
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getSummaryForCurrentUser() -> GolfSummary? {
        let ad = UIApplication.shared.delegate as! AppDelegate
        let userID = ad.user?.uid ?? game!.players[0].uid
        
        return game!.getTotalsForUID(userID)
    }
    
    func updateCell(game: GolfGame) {
        self.game = game
        
        let summary = self.getSummaryForCurrentUser()
        
        self.timeSinceLabel.text = game.date.timeAgoDisplay()
        self.numberOfHolesLabel.text = game.holes.count > 1
            ? "\(game.holes.count) holes"
            : "\(game.holes.count) hole"
        if (summary != nil) {
            let strokesRelativeToPar = summary!.strokesRelativeToPar()
            if (strokesRelativeToPar > 0) {
                self.youShotLabel.text =
                    "You shot: \(summary!.totalStrokes) (+\(summary!.strokesRelativeToPar()))"
            }
            else {
                self.youShotLabel.text =
                    "You shot: \(summary!.totalStrokes) (\(summary!.strokesRelativeToPar()))"
            }
        }
        else {
            self.youShotLabel.isHidden = true
        }
        self.numberOfPlayersLabel.text =
            "\(game.players.count) Player\(game.players.count > 1 ? "s" : "")"
    }

}
