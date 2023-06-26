//
//  NewGameViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-02-29.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

protocol GolfGameCreationHelper {
    func addNewGolfer()
}

class NewGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GolfGameCreationHelper {
    
    var golferCells: [NewGolferCell] = []
    var passbackDelegate: GolfGameCallback?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var golferTableView: UITableView!
    @IBOutlet weak var startGameButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        golferTableView.delegate = self
        golferTableView.dataSource = self
        
        startGameButton.layer.cornerRadius = 5
    }
    
    // MARK: - Create Game
    // Create new game, and then dismiss view controller
    @IBAction func createGameClicked(_ sender: Any) {
        var players: [Player] = []
        for golfer in golferCells {
            players.append(golfer.getGolfer())
        }
        
        
        let tabBarController = self.tabBarController
        if (tabBarController is GolfGameCallback) {
            let gameCallback = tabBarController as! GolfGameCallback
            gameCallback.createNewGame(golfers: players)
        }
    }
    
    func setupView() {
        if (appDelegate.user != nil) {
            let newGolfer = golferTableView.dequeueReusableCell(withIdentifier: "InvitedGolferTableViewCell") as! InvitedGolferTableViewCell
            
            newGolfer.setGolfer(
                name: appDelegate.user?.displayName ?? "You",
                uid: appDelegate.user?.uid
            )
            golferCells = [newGolfer]
        }
        else {
            addNewGolfer()
        }
    }
    
    // MARK: - GolfGameCreationHelper
    
    func addNewGolfer() {
        let newGolfer = golferTableView.dequeueReusableCell(withIdentifier: "NewGolferTableViewCell") as! NewGolferTableViewCell
        newGolfer.setGolferNumber(golferCells.count+1)
        newGolfer.nameField.text = ""
        newGolfer.nameField.delegate = self

        golferCells.append(newGolfer)
        
        self.golferTableView.insertRows(at: [IndexPath(row: golferCells.count-1, section: 0)], with: .automatic)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return golferCells.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < golferCells.count) {
            return golferCells[indexPath.row]
        }
        
        let cell = golferTableView.dequeueReusableCell(
            withIdentifier: "AddNewPlayerButtonViewCell"
        ) as! AddNewPlayerTableViewCell
        cell.golfGameCreationHelper = self
        return cell
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(false)
    }
}
