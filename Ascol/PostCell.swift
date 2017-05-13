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
    
    
    
    var post: Post!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        self.post = post
        self.postLbl.text = post.title
        self.likesCount.text = post.likes
        self.createdAt.text = dateFormatter.string(from: NSDate(timeIntervalSince1970: post.date) as Date)
        
        if post.imageURL != "" {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            
            if let img = ProfileVC.imageCache.object(forKey: post.imageURL as NSString) {
                self.profileImg.image = img
            } else {
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("AN ERROR!!!!!!!!!!!!")
                    } else {
                        print("Image DOWNLOADED!!!!!!!!!!!!!!!!!!!!")
                        if let imgData = data {
                            if let image = UIImage(data: imgData) {
                                self.profileImg.image = image
                                ProfileVC.imageCache.setObject(image, forKey: self.post.imageURL as NSString)
                            }
                        }
                    }
                    
                })
            }
        }
    }

}
