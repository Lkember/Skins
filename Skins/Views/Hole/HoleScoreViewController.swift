//
//  HoleScoreViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

protocol HoleScoreCallback {
    func extraSkinToggleChanged(cell: GolferScoreTableViewCell)
    func strokesUpdated(cell: GolferScoreTableViewCell, strokes: Int)
}

class HoleScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HoleScoreCallback {
    
    @IBOutlet weak var golferTableView: UITableView!
    @IBOutlet weak var parForHole: UISegmentedControl!
    @IBOutlet weak var numSkinsLabel: UILabel!
    @IBOutlet weak var extraSkinLabel: UILabel!
    var golfGameCallback: GolfGameCallback?
    var titlePassback: TitleUpdateCallback?
    var currHole: Hole = Hole.init()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        golferTableView.delegate = self
        golferTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titlePassback?.updateTitle(hole: currHole.holeNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        golfGameCallback?.updateHole(hole: currHole)
    }
    
    func updateHole(hole: Hole) {
        currHole = hole
    }
    
    func updateUI() {
        parForHole.selectedSegmentIndex = currHole.par - 3
        if (currHole.carryOverSkins != 1) {
            numSkinsLabel.text = "\(currHole.carryOverSkins) skins carried over"
        }
        else {
            numSkinsLabel.text = "\(currHole.carryOverSkins) skin carried over"
        }
        
        navigationItem.title = "Hole \(currHole.holeNumber)"
        
        if (currHole.par <= 3) {
            extraSkinLabel.text = "Closest to Pin"
        }
        else {
            extraSkinLabel.text = "Longest Drive"
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currHole.golfers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GolferScoreTableViewCell"
        let cell = golferTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! GolferScoreTableViewCell
        
        let golfer = currHole.golfers[indexPath.row]
        cell.updateCell(name: golfer.playerName, strokes: golfer.strokes, extraSkin: golfer.extraSkin)
        cell.callback = self
        return cell
    }
    
    // MARK: - Actions
    @IBAction func parWasChanged(_ sender: Any) {
        currHole.par = parForHole.selectedSegmentIndex + 3
        updateUI()
    }
    
    // MARK: - HoleScoreCallback
    
    func extraSkinToggleChanged(cell: GolferScoreTableViewCell) {
        var indexPath = IndexPath.init(row: 0, section: 0)
        
        for i in 0..<currHole.golfers.count {
            indexPath.row = i
            
            if let tCell = golferTableView.cellForRow(at: indexPath) as? GolferScoreTableViewCell {
                if (tCell != cell) {
                    tCell.deselectExtraSkin()
                    currHole.golfers[i].extraSkin = false
                }
                else {
                    currHole.golfers[i].extraSkin = true
                }
            }
        }
    }
    
    func strokesUpdated(cell: GolferScoreTableViewCell, strokes: Int) {
        if let indexPath = golferTableView.indexPath(for: cell) {
            currHole.golfers[indexPath.row].strokes = strokes
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }

}
