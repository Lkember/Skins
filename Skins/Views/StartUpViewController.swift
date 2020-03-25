//
//  StartUpViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-02-17.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

protocol NewGameCallback {
    func createNewGame(golfers: [String])
}

class StartUpViewController: UIViewController, NewGameCallback {
    var currentGame: GolfGame?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var currentGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        currentGameButton.isHidden = currentGame == nil
    }
    
    // MARK: - Button Press
    @IBAction func playButtonPressed(_ sender: Any) {
        
    }
    
    // MARK: - NewGamePassback
    
    func createNewGame(golfers: [String]) {
        currentGame = GolfGame.init(names: golfers)
        currentGameButton.isHidden = currentGame == nil
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let dvc = segue.destination as? HoleScoreHelperViewController {
            dvc.game = currentGame!
        }
        else if let dvc = segue.destination as? NewGameViewController {
            dvc.passbackDelegate = self
        }
    }

}
