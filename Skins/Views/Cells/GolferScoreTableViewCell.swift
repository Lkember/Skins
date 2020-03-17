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
    @IBOutlet weak var numberOfStrokes: UILabel!
    @IBOutlet weak var numStrokesStepper: UIStepper!
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
        
        longestDriveSwitch.isOn = ld
        closestToPinSwitch.isOn = ctp
        numStrokesStepper.value = Double(strokes)
        updateStrokesLabel(numStrokes: strokes)
    }
    
    func updateStrokesLabel(numStrokes: Int) {
        if (numStrokes == 1) {
            numberOfStrokes.text = "1 stroke"
        }
        else {
            numberOfStrokes.text = "\(numStrokes) strokes"
        }
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
    
    @IBAction func numStrokesChanged(_ sender: Any) {
        let numStrokes = Int.init(numStrokesStepper.value)
        callback?.strokesUpdated(cell: self, strokes: numStrokes)
        
        updateStrokesLabel(numStrokes: numStrokes)
    }
}
