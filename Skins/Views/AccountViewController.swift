//
//  AccountViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-04-16.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

protocol SignInPassback {
    func userSignedIn()
}

class AccountViewController: UIViewController, SignInPassback {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    // MARK: - UI Updates
    func updateUI() {
        setSignOutButtonVisibility()
        updateAccountLabels()
    }
    
    private func setSignOutButtonVisibility() {
        if (appDelegate.user == nil || !appDelegate.user!.isSignedIn()) {
            self.navigationItem.rightBarButtonItem = nil
            self.signInButton.isHidden = false
        }
        else {
            self.navigationItem.rightBarButtonItem = signOutButton
            self.signInButton.isHidden = true
        }
    }
    
    private func updateAccountLabels() {
        if (appDelegate.user != nil && appDelegate.user!.isSignedIn()) {
            nameLabel.text = "Name: \(appDelegate.user!.user!.displayName ?? "N/A")"
            emailLabel.text = "Email: \(appDelegate.user!.user!.email ?? "N/A")"
            emailLabel.isHidden = false
        }
        else {
            nameLabel.text = "Not signed in, login below"
            emailLabel.isHidden = true
        }
    }
    
    // MARK: - SignInPassback
    func userSignedIn() {
        updateUI()
    }
    
    // MARK: - IBActions

    @IBAction func signOutOfAccount(_ sender: Any) {
        if (appDelegate.user != nil) {
            appDelegate.user!.signOut()
        }
        
        updateUI()
    }
    
    @IBAction func signInButtonTouch(_ sender: Any) {
        appDelegate.signInPassback = self
        appDelegate.presentUserWithLoginPrompt(vc: self)
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
