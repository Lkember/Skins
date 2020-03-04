//
//  HoleScoreViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-04.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class HoleScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var golferTableView: UITableView!
    @IBOutlet weak var parForHole: UISegmentedControl!
    @IBOutlet weak var nextHoleButton: UIButton!
    @IBOutlet weak var endGameButton: UIButton!
    var game: GolfGame = GolfGame.init()
    
    // MARK: - Creation
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        golferTableView.delegate = self
        golferTableView.dataSource = self
    }
    
    func createNewGame(names: [String]) {
        game = GolfGame.init(names: names)
    }
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
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
