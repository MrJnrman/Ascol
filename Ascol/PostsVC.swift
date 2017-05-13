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

class PostsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var profile = Profile()
    var filteredPosts = [Post]()
    var posts: [Post]!
    var inSearchMode = false
//    static var username: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        
        
        posts = [Post]()
        
        DataService.ds.REF_POSTS.observe( .value, with: { (snapshot) in
            
            if self.posts.count > 0 {
                self.posts = [Post]()
            }
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
                
                self.posts = self.posts.sorted(by: {$0.date < $1.date})
            }
            
            self.tableView.reloadData()
        })

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            tableView.reloadData()
        } else {
            
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            
            print(lower)
            
            filteredPosts = posts.filter({ $0.tags.range(of: lower) != nil})
            print(filteredPosts.count)
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let userId = (FIRAuth.auth()?.currentUser?.uid)!
        DataService.ds.REF_USERS.child(userId).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            self.profile.name = value?["name"] as? String ?? ""
            self.profile.imageUrl = value?["imageURL"] as? String ?? ""
            self.profile.provider = value?["provider"] as? String ?? ""
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            let post: Post!
            
            if inSearchMode {
                post = filteredPosts[indexPath.row]
            } else {
                post = posts[indexPath.row]
            }
            
            cell.configureCell(post: post)
            
            return cell
        } else {
            return PostCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPosts.count
        }
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post: Post!
        
        if inSearchMode {
            post = filteredPosts[indexPath.row]
        } else {
            post = posts[indexPath.row]
        }

        performSegue(withIdentifier: "PostDetail", sender: post)
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
        
        if segue.identifier == "CreatePost" {
            if let createPostVC = segue.destination as? CreatePostVC {
                if let profile = sender as? Profile {
                    createPostVC.profile = profile
                }
            }
        }
        
        if segue.identifier == "PostDetail" {
            
            if let detailVC = segue.destination as? PostDetailVC {
                if let post = sender as? Post {
                    detailVC.post = post
                }
            }
        }
    }
    
    
    @IBAction func createPostPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "CreatePost", sender: profile)
    }
    
    
}
