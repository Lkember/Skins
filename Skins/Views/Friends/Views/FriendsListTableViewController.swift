//
//  FriendsListTableViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-06-07.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit
import Firebase

class FriendsListTableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var friends: [TinyUser] = []
    var pendingFriends: [TinyUser] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.title = "Friends"
        
        getFriendsList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Firestore
    func getFriendsList() {
        self.friends.removeAll()
        self.pendingFriends.removeAll()
        
        if (appDelegate.user!.isSignedIn()) {
            
            let docRef = appDelegate.firebase!.db.collection(FirebaseHelper.collection).document(appDelegate.user!.user!.uid).collection(FirebaseHelper.friendsList)
            
            docRef.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    return
                }
                
                for doc in querySnapshot!.documents {
                    let user = TinyUser.init(doc.data(), id: doc.documentID)
                    
                    if (doc.data()["accepted"] as! Bool) {
                        self.friends.append(user)
                    }
                    else {
                        self.pendingFriends.append(user)
                    }
                }
                
                self.friends = self.friends.sorted(by: {$0.displayName < $1.displayName })
                self.pendingFriends = self.pendingFriends.sorted(by: {$0.displayName < $1.displayName })
                
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if (pendingFriends.count > 0) {
            return 2
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.numberOfSections == 1 || section == 1 {
            return friends.count
        }
        
        return pendingFriends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicFriendCell", for: indexPath)
        
        if (tableView.numberOfSections == 1 || indexPath.section == 1) {
            cell.textLabel!.text = friends[indexPath.row].displayName
            cell.detailTextLabel!.text = friends[indexPath.row].email
        }
        else {
            cell.textLabel!.text = pendingFriends[indexPath.row].displayName
            cell.detailTextLabel!.text = pendingFriends[indexPath.row].email
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableView.numberOfSections == 1) {
            return "Friends List"
        }
        else if (section == 0) {
            return "Pending Friends"
        }
        else {
            return "Friends List"
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
