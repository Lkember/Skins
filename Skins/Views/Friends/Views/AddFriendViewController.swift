//
//  AddFriendViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-06-10.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit
import Contacts

class AddFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var contactsTableView: UITableView!
    var usersContacts: CNContactStore = CNContactStore.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        if (status == .notDetermined) {
            usersContacts.requestAccess(for: CNEntityType.contacts, completionHandler: { (result, err) -> Void in
                
                if (err != nil) {
                    print("Error getting permission: \(String(describing: err))")
                }
            })
        }
        
        var contacts = [CNContact]()
        if (status == .authorized) {
            // TODO: Get contacts
            let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as NSString, CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey as NSString])
            do {
                try usersContacts.enumerateContacts(with: request) { contact, stop in
                    contacts.append(contact)
                }
            } catch {
                print(error)
            }
        }
        
        print("\(contacts.count) contacts")
    }
    
//    func presentSettingsActionSheet() {
//        let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to ...", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
//            let url = URL(string: UIApplicationOpenSettingsURLString)!
//            UIApplication.shared.open(url)
//        })
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        present(alert, animated: true)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
