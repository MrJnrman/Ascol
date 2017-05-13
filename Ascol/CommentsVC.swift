//
//  CommentsVC.swift
//  Ascol
//
//  Created by Jamel Reid  on 5/2/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTxtField: UITextField!
    
    var comments: [Comment]!
    var post: Post!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        commentTxtField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        comments = [Comment]()
        
        DataService.ds.REF_COMMENTS.child(post.commentId).observe( .value, with: { (snapshot) in
            
            if self.comments.count > 0 {
                self.comments = [Comment] ()
            }
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("Comment \(snap)")
                    
                    if let commentDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let comment = Comment(commentData: commentDict)
                        self.comments.append(comment)
                    }
                }
                
                self.comments = self.comments.sorted(by: {$0.date < $1.date})
            }
            
            self.tableView.reloadData()
        
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let comment = comments[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell {
            cell.configureCell(comment: comment)
            
            return cell
        } else {
            return CommentCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    @IBAction func submitBtnPressed(_ sender: UIButton) {
        
        let userId = (FIRAuth.auth()?.currentUser?.uid)!
//        var displayName: String!
        
        DataService.ds.REF_USERS.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            print(name)
            
            let postKey = DataService.ds.REF_COMMENTS.child(self.post.commentId).childByAutoId().key
            
            if let text = self.commentTxtField.text, !text.isEmpty {
                let commentData = ["message": text,
                                   "creator": name,
                                   "date": NSDate().timeIntervalSince1970] as [String : Any]
                
                DataService.ds.REF_COMMENTS.child(self.post.commentId).child(postKey).setValue(commentData)
            }
            
            self.commentTxtField.text = ""
            
            
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func KeyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -215
    }
    
    func KeyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
