//
//  PostDetailVC.swift
//  Ascol
//
//  Created by Jamel Reid  on 5/2/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit
import Firebase

class PostDetailVC: UIViewController {
    
    var post: Post!
    
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var commentsLbl: UILabel!
    @IBOutlet weak var creatorImage: UIImageView!
    @IBOutlet weak var createLbl: UILabel!
    @IBOutlet weak var courseLbl: UILabel!
    @IBOutlet weak var likeLbl: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        typeLbl.text = post.type
        titleLbl.text = post.title
        categoryLbl.text = post.category
        locationLbl.text = post.location
        courseLbl.text = post.course
        detailsLbl.text = post.details
        createLbl.text = post.creator
        commentsLbl.text = post.comments
        likeLbl.text = post.likes
        
        if post.imageURL != "" {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            
            if let img = ProfileVC.imageCache.object(forKey: post.imageURL as NSString) {
                self.creatorImage.image = img
                
            } else {
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("AN ERROR!!!!!!!!!!!!")
                    } else {
                        print("Image DOWNLOADED!!!!!!!!!!!!!!!!!!!!")
                        if let imgData = data {
                            if let image = UIImage(data: imgData) {
                                self.creatorImage.image = image
                                ProfileVC.imageCache.setObject(image, forKey: self.post.imageURL as NSString)
                            }
                        }
                    }
                    
                })
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commentsButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "Comments", sender: post)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Comments" {
            if let commentVC = segue.destination as? CommentsVC {
                if let post = sender as? Post {
                    commentVC.post = post
                }
            }
        }
    }
    
    @IBAction func likeBtnPressed(_ sender: UIButton) {
        
        let likes = Int(likeLbl.text!)! + 1
        
        DataService.ds.REF_POSTS.child(post.commentId).child("likes").setValue(likes)
        
        likeLbl.text = "\(likes)"
        
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
