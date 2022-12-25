//
//  HoleScoreHelperViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-07.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

protocol PageControlCallback {
    func PageCountChanged()
}

protocol TitleUpdateCallback {
    func updateTitle(hole: Int)
}

class HoleScoreHelperViewController: UIViewController, TitleUpdateCallback {
    var game = GolfGame.init()
    var passbackDelegate: GameCallback?
    var pageControlCallback: PageControlCallback?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var golfHoleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func newHoleTouched(_ sender: Any) {
        game.summarizeHoles(nil, startNextGame: true)
        pageControlCallback?.PageCountChanged()
    }
    
    @IBAction func endGameTouched(_ sender: Any) {
        game.summarizeHoles(nil, startNextGame: false)
        appDelegate.user!.stats.writeNewGame(game: game)
        passbackDelegate?.gameIsFinished()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewScorecardTouched(_ sender: Any) {
        game.summarizeHoles(nil, startNextGame: false)
    }
    
    // MARK: - UpdateTitleCallback
    func updateTitle(hole: Int) {
        self.navigationItem.title = "Hole \(hole)"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? HolePageViewController {
            vc.game = self.game
            self.pageControlCallback = vc
            vc.holeScoreHelperVC = self
        }
        else if let dvc = segue.destination as? ScoresheetViewController {
            dvc.game = self.game
        }
    }

}
