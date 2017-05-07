//
//  MainViewVC.swift
//  Ascol
//
//  Created by Jamel Reid  on 4/30/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class PostsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var profile = Profile()
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe( .value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let userId = (FIRAuth.auth()?.currentUser?.uid)!
        DataService.ds.REF_USERS.child(userId).observeSingleEvent(of: .value, with: {(snapshot) in
            print("GOT IN")
            let value = snapshot.value as? NSDictionary
            self.profile.name = value?["name"] as? String ?? ""
            self.profile.imageUrl = value?["imageURL"] as? String ?? ""
            self.profile.provider = value?["provider"] as? String ?? ""
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print("TITLE: \(post.title)")
        
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "PostDetail", sender: nil)
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        if removeSuccessful == true {
            do {
                try FIRAuth.auth()?.signOut()
                performSegue(withIdentifier: "SignInVC", sender: nil)
            } catch let err as NSError {
                print(err.debugDescription)
            }
            
        }

    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "Profile", sender: profile)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Profile" {
            if let profileVC = segue.destination as? ProfileVC {
                if let profile = sender as? Profile {
                    profileVC.profile = profile
                }
            }
        }
    }
    
}
