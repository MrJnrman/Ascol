//
//  PostCell.swift
//  Ascol
//
//  Created by Jamel Reid  on 5/1/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    
    
    
    var post: Post!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func configureCell(post: Post, image: UIImage?) {
//        self.post = post
//        self.postLbl.text = post.title
//        self.likesCount.text = post.likes
//        self.viewsCount.text = post.views
//        self.createdAt.text = post.date
//        
//        if image != nil  {
//            self.profileImg.image = image
//        } else {
//            if let imageURL = post.imageURL {
//                let ref = FIRStorage.storage().reference(forURL: imageURL)
//                ref.data(withMaxSize: 2 * 1024 * 1024) { (data, error) in
//                    if error != nil {
//                        print("ERROR =========>")
//                    } else {
//                        print("Image Downloaded from firebase storage")
//                        let image = UIImage(data: data!)
//                    }
//                }
//            }
//        }
//    }

}
