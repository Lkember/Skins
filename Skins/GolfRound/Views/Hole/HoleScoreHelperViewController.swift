//
//  HoleScoreHelperViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-07.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

protocol PageControlCallback {
    func pageCountChanged()
}

protocol TitleUpdateCallback {
    func updateTitle(hole: Int)
}

class HoleScoreHelperViewController: UIViewController, TitleUpdateCallback {
    var passbackDelegate: GolfGameCallback?
    var pageControlCallback: PageControlCallback?
    @IBOutlet weak var holeNumberLabel: UILabel!
    
    @IBOutlet weak var golfHoleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let homeVC = self.tabBarController as? HomeTabViewController {
            self.passbackDelegate = homeVC
        }
        else {
            print("ERROR - Game not created??")
        }
    }
    
    @IBAction func newHoleTouched(_ sender: Any) {
        self.passbackDelegate?.updateHoles(startNextHole: true)
        pageControlCallback?.pageCountChanged()
    }
    
    @IBAction func endGameTouched(_ sender: Any) {
        self.passbackDelegate?.endGame()
        
        // TODO - This probably doesn't work
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewScorecardTouched(_ sender: Any) {
        self.passbackDelegate?.updateHoles(startNextHole: false)
    }
    
    // MARK: - UpdateTitleCallback
    func updateTitle(hole: Int) {
        self.holeNumberLabel.text = "Hole #\(hole)"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (self.passbackDelegate == nil) {
            self.passbackDelegate = self.tabBarController as? GolfGameCallback
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? HolePageViewController {
            vc.game = self.passbackDelegate!.liveGame!
            vc.golfGameCallback = self.passbackDelegate
            
            self.pageControlCallback = vc
            vc.holeScoreHelperVC = self
        }
        else if let dvc = segue.destination as? ScoresheetViewController {
            dvc.game = self.passbackDelegate!.liveGame!
        }
    }

}
