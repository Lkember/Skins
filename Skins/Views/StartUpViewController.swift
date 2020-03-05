//
//  StartUpViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-02-17.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

protocol GolfGamePassback {
    func createNewGame(golfers: [String])
    func updateCurrentGame(game: GolfGame)
}

class StartUpViewController: UIViewController, GolfGamePassback {
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
    
    func updateCurrentGame(game: GolfGame) {
        currentGame = game
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let dvc = segue.destination as? HoleScoreViewController {
            dvc.continueGameInProgress(game: currentGame!)
            dvc.passbackDelegate = self
        }
        else if let dvc = segue.destination as? NewGameViewController {
            dvc.passbackDelegate = self
        }
    }

}
