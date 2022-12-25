//
//  StatsViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-05-02.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit
import Firebase

class StatsViewController: UIViewController {
    
//    static let collection = "golf-stats"
//    static let gameCollection = "Games"
//    var dbRef: Firestore!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.appDelegate.user?.stats.loadLastTenGames()
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
