//
//  HoleScoreViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

protocol HoleScoreCallback {
    func longestDriveSelected(cell: GolferScoreTableViewCell)
    func closestToPinSelected(cell: GolferScoreTableViewCell)
    func strokesUpdated(cell: GolferScoreTableViewCell, strokes: Int)
}

class HoleScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HoleScoreCallback {
    
    @IBOutlet weak var golferTableView: UITableView!
    @IBOutlet weak var parForHole: UISegmentedControl!
    @IBOutlet weak var nextHoleButton: UIButton!
    @IBOutlet weak var endGameButton: UIButton!
    @IBOutlet weak var numSkinsLabel: UILabel!
    var passbackDelegate: GolfGamePassback?
    var game: GolfGame = GolfGame.init()
    var par: Int = 4
    
    // MARK: - Creation
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        golferTableView.delegate = self
        golferTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        par = game.golfers.first!.holes.last!.par
        navigationController?.title = "Hole \(game.currentHole)"
        parForHole.selectedSegmentIndex = par - 3
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        passbackDelegate?.updateCurrentGame(game: self.game)
    }
    
    func createNewGame(names: [String]) {
        game = GolfGame.init(names: names)
    }
    
    func continueGameInProgress(game: GolfGame) {
        self.game = game
        
        if (game.golfers.count > 0 && game.golfers.first!.holes.count > 0) {
            self.par = game.golfers.first!.holes.last!.par
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.golfers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GolferScoreTableViewCell"
        let cell = golferTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! GolferScoreTableViewCell
        let currHole = game.golfers[indexPath.row].holes.last
        let name = game.golfers[indexPath.row].playerName
        
        cell.updateCell(name: name, strokes: currHole?.strokes ?? 0, ld: currHole?.longestDrive ?? false, ctp: currHole?.closestToPin ?? false)
        
        cell.callback = self
        return cell
    }
    
    // MARK: - Actions
    @IBAction func parWasChanged(_ sender: Any) {
        par = parForHole.selectedSegmentIndex + 3
        
        for golfer in game.golfers {
            golfer.holes.last!.updatePar(par: par)
        }
    }
    
    // MARK: - HoleScoreCallback
    func longestDriveSelected(cell: GolferScoreTableViewCell) {
        var indexPath = IndexPath.init(row: 0, section: 0)
        
        for i in 0..<game.golfers.count {
            indexPath.row = i
            
            if let tCell = golferTableView.cellForRow(at: indexPath) as? GolferScoreTableViewCell {
                if (tCell != cell) {
                    tCell.deselectLD()
                    game.golfers[i].holes.last!.longestDrive = false
                }
                else {
                    game.golfers[i].holes.last!.longestDrive = true
                }
            }
        }
    }
    
    func closestToPinSelected(cell: GolferScoreTableViewCell) {
        var indexPath = IndexPath.init(row: 0, section: 0)
        
        for i in 0..<game.golfers.count {
            indexPath.row = i
            
            if let tCell = golferTableView.cellForRow(at: indexPath) as? GolferScoreTableViewCell {
                if (tCell != cell) {
                    tCell.deselectCP()
                    game.golfers[i].holes.last!.closestToPin = false
                }
                else {
                    game.golfers[i].holes.last!.closestToPin = true
                }
            }
        }
    }
    
    func strokesUpdated(cell: GolferScoreTableViewCell, strokes: Int) {
        if let indexPath = golferTableView.indexPath(for: cell) {
            game.golfers[indexPath.row].holes.last!.strokes = strokes
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
