//
//  GolferScoreTableViewCell.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-03.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class GolferScoreTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var golferName: UILabel!
    @IBOutlet weak var numberOfStrokes: UITextField!
    @IBOutlet weak var longestDriveSwitch: UISwitch!
    @IBOutlet weak var closestToPinSwitch: UISwitch!
    var callback: HoleScoreCallback?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(name: String, strokes: Int, ld: Bool, ctp: Bool) {
        golferName.text = name
        numberOfStrokes.text = "\(strokes)"
        longestDriveSwitch.isOn = ld
        closestToPinSwitch.isOn = ctp
        
        numberOfStrokes.delegate = self
    }
    
    func deselectLD() {
        longestDriveSwitch.isOn = false
    }
    
    func deselectCP() {
        closestToPinSwitch.isOn = false
    }
    
    @IBAction func longestDriveSwitched(_ sender: Any) {
        callback?.longestDriveSelected(cell: self)
    }
    
    @IBAction func closestToPinSwitched(_ sender: Any) {
        callback?.closestToPinSelected(cell: self)
    }
    
    @IBAction func strokesUpdated(_ sender: Any) {
        callback?.strokesUpdated(cell: self, strokes: Int.init(numberOfStrokes.text ?? "0") ?? 0)
    }
    
}
