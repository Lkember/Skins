//
//  NewGameViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-02-29.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

protocol NewGolferCell: UITableViewCell {
    func getGolfer() -> Player
}

class NewGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var golferCells: [NewGolferCell] = []
    var numGolfersSelected: Int = 4
    var passbackDelegate: GolfGameCallback?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var golferTableView: UITableView!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        golferTableView.delegate = self
        golferTableView.dataSource = self
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Create Game
    // Create new game, and then dismiss view controller
    @IBAction func createGameClicked(_ sender: Any) {
        var players: [Player] = []
        for golfer in golferCells {
            players.append(golfer.getGolfer())
        }
        
        self.passbackDelegate?.liveGame?.players = players
        
        let tabBarController = self.tabBarController
        if (tabBarController is GolfGameCallback) {
            let gameCallback = tabBarController as! GolfGameCallback
            gameCallback.createNewGame(golfers: players)
        }
//        passbackDelegate?.createNewGame(golfers: names)
//        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        if (appDelegate.user != nil) {
            let newGolfer = golferTableView.dequeueReusableCell(withIdentifier: "InvitedGolferTableViewCell") as! InvitedGolferTableViewCell
            
            newGolfer.setGolfer(
                name: appDelegate.user?.displayName ?? "You",
                uid: appDelegate.user?.uid
            )
            golferCells.append(newGolfer)
        }
        
        addNewGolfers()
        self.updateButtonSelection()
    }
    
    // MARK: - TableUpdater
    @IBAction func oneGolferSelected(_ sender: Any) {
        updateGolferSelected(1)
    }
    
    @IBAction func twoGolfersSelected(_ sender: Any) {
        updateGolferSelected(2)
    }
    
    @IBAction func threeGolfersSelected(_ sender: Any) {
        updateGolferSelected(3)
    }
    
    @IBAction func fourGolfersSelected(_ sender: Any) {
        updateGolferSelected(4)
    }
    
    func updateGolferSelected(_ numGolfers: Int) {
        numGolfersSelected = numGolfers
        if (golferCells.count > numGolfersSelected) {
            removeExcessGolfers()
        }
        else if (golferCells.count < numGolfersSelected) {
            addNewGolfers()
        }
        updateButtonSelection()
    }
    
    // MARK: - Golfer Helper
    
    func removeExcessGolfers() {
        if (golferCells.count - numGolfersSelected == 0) {
            return
        }
        
        for i in (numGolfersSelected..<golferCells.count).reversed() {
            golferCells.remove(at: i)
        }
            
//            let indexPath = IndexPath.init(row: golfers.count-1, section: 0)
//            self.golferTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        
        self.golferTableView.reloadData()
    }
    
    func addNewGolfers() {
        let diff = numGolfersSelected - golferCells.count
        if (diff > 0) {
            for _ in 0..<diff {
                let newGolfer = golferTableView.dequeueReusableCell(withIdentifier: "NewGolferTableViewCell") as! NewGolferTableViewCell
                newGolfer.setGolferNumber(golferCells.count+1)
                newGolfer.nameField.text = ""
                newGolfer.nameField.delegate = self
                
                golferCells.append(newGolfer)
                
    //            let indexPath = IndexPath.init(row: golfers.count-1, section: 0)
    //            self.golferTableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.left)
            }
        }
        self.golferTableView.reloadData()
    }
    
    func updateButtonSelection() {
        oneButton.isSelected = false
        twoButton.isSelected = false
        threeButton.isSelected = false
        fourButton.isSelected = false
        
        switch numGolfersSelected {
            case 1:
                oneButton.isSelected = true
                break
            
            case 2:
                twoButton.isSelected = true
                break
            
            case 3:
                threeButton.isSelected = true
                break
            
            case 4:
                fourButton.isSelected = true
                break
            
            default:
                break
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numGolfersSelected
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return golferCells[indexPath.row]
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(false)
    }
}
