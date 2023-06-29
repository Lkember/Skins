//
//  StatsViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-05-02.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit
import Firebase

class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var gameListTableView: UITableView!
    static let collection = "golf-stats"
    static let gameCollection = "Games"
    var dbRef: Firestore!
    var lastTenGames: [GolfGame] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let refreshControl = UIRefreshControl()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameListTableView.delegate = self
        loadPrevGames()
        
        gameListTableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(
            self,
            action: #selector(didPullToRefresh),
            for: .valueChanged
        )
    }
    
    @objc private func didPullToRefresh() {
        print("didPullToRefresh")
        self.loadPrevGames()
    }
    
    private func didEndRefresh() {
        print("didEndRefresh")
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    func loadPrevGames() {
        self.appDelegate.user?.loadLastTenGames() { (result, error) in
            self.prevGamesLoaded(result: result, error: error)
            self.didEndRefresh()
        }
        
        lastTenGames = self.appDelegate.user?.stats.getLastTenGames() ?? []
    }
    
    func prevGamesLoaded(result: [GolfGame]?, error: Error?) {
        if (error != nil) {
            // TODO - Handle Error
            print("Error retrieving data")
        }
        
        if (result != nil) {
            self.lastTenGames = result!
            self.gameListTableView.reloadData()
        }
    }
    
    // MARK: - Table Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastTenGames.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PreviousGameCell",
            for: indexPath
        ) as! PreviousGamesTableViewCell
        
        cell.updateCell(game: lastTenGames[indexPath.row])
        
        return cell
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
