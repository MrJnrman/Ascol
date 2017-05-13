//
//  CommentCell.swift
//  Ascol
//
//  Created by Jamel Reid  on 5/2/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    
    @IBOutlet weak var messgeLbl: UILabel!
    @IBOutlet weak var creatorLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(comment: Comment) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        self.messgeLbl.text = comment.message
        self.creatorLbl.text = comment.creator
        self.dateLbl.text = dateFormatter.string(from: NSDate(timeIntervalSince1970: comment.date) as Date)
    }

}
