//
//  ScoresheetViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-12.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class ScoresheetViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let reuseIdentifier = "ScoresheetCollectionCell"
    var layout: ScoresheetViewLayout = ScoresheetViewLayout.init()
    
    @IBOutlet weak var scoresheetCollection: UICollectionView!
    var game: GolfGame = GolfGame.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scoresheetCollection.delegate = self
        scoresheetCollection.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        layout.game = game
        scoresheetCollection.setCollectionViewLayout(layout, animated: false)
    }

    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.holes.count + 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return game.holes.first!.golfers.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = scoresheetCollection.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ScoresheetCollectionViewCell
        cell.backgroundColor = .white
        
        if (indexPath.section == 0) {
            cell.backgroundColor = #colorLiteral(red: 0.818490684, green: 0.8186288476, blue: 0.818472445, alpha: 1)
            if (indexPath.row == 0) {
                cell.label.text = ""
            }
            else if (indexPath.row == game.holes.count + 1) {
                cell.label.text = "Totals"
            }
            else {
                cell.label.text = "Hole \(indexPath.row)"
            }
        }
        else if (indexPath.row == 0) {
            cell.label.text = "\(game.holes.first!.golfers[indexPath.section-1].playerName)"
            cell.backgroundColor = #colorLiteral(red: 0.818490684, green: 0.8186288476, blue: 0.818472445, alpha: 1)
        }
        else if (indexPath.row > game.holes.count) {
            let summary = game.getTotals(indexPath.section-1)
            cell.label.text = "\(summary.totalStrokes) (\(summary.totalSkins))"
        }
        else {
            let golferScore = game.holes[indexPath.row-1].golfers[indexPath.section-1]
            cell.label.text = "\(golferScore.strokes) (\(golferScore.skins))"
        }
        
        return cell
    }
    
}
