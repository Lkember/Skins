//
//  NewGameViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-02-29.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var golfers: [NewGolferTableViewCell] = []
    var numGolfersSelected: Int = 0
    var passbackDelegate: GolfGameCallback?
    @IBOutlet weak var golferTableView: UITableView!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        golferTableView.delegate = self
        golferTableView.dataSource = self
        
        updateButtonSelection()
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
        var names: [String] = []
        for golfer in golfers {
            names.append(golfer.getGolferName())
        }
        
        passbackDelegate?.createNewGame(golfers: names)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableUpdater
    @IBAction func oneGolferSelected(_ sender: Any) {
        numGolfersSelected = 1
        
        if (golfers.count > numGolfersSelected) {
            removeExcessGolfers()
        }
        else if (golfers.count < numGolfersSelected) {
            addNewGolfers()
        }
        updateButtonSelection()
    }
    
    @IBAction func twoGolfersSelected(_ sender: Any) {
        numGolfersSelected = 2
        
        if (golfers.count > numGolfersSelected) {
            removeExcessGolfers()
        }
        else if (golfers.count < numGolfersSelected) {
            addNewGolfers()
        }
        updateButtonSelection()
    }
    
    @IBAction func threeGolfersSelected(_ sender: Any) {
        numGolfersSelected = 3
        if (golfers.count > numGolfersSelected) {
            removeExcessGolfers()
        }
        else if (golfers.count < numGolfersSelected) {
            addNewGolfers()
        }
        updateButtonSelection()
    }
    
    @IBAction func fourGolfersSelected(_ sender: Any) {
        numGolfersSelected = 4
        
        if (golfers.count < numGolfersSelected) {
            addNewGolfers()
        }
        updateButtonSelection()
    }
    
    // MARK: - Golfer Helper
    
    func removeExcessGolfers() {
        while (golfers.count != numGolfersSelected) {
            golfers.removeLast()
            
//            let indexPath = IndexPath.init(row: golfers.count-1, section: 0)
//            self.golferTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        }
        
        self.golferTableView.reloadData()
    }
    
    func addNewGolfers() {
        let diff = numGolfersSelected - golfers.count
        for _ in 0..<diff {
            let newGolfer = golferTableView.dequeueReusableCell(withIdentifier: "NewGolferTableViewCell") as! NewGolferTableViewCell
            newGolfer.setGolferNumber(golfers.count+1)
            golfers.append(newGolfer)
            
//            let indexPath = IndexPath.init(row: golfers.count-1, section: 0)
//            self.golferTableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.left)
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
        if (section == 0) {
            return numGolfersSelected
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return golfers[indexPath.row]
    }
}
