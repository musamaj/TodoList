//
//  CommentDetailCell.swift
//  TodoList
//
//  Created by Usama Jamil on 05/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class CommentDetailCell: UITableViewCell {

    @IBOutlet weak var imgProfile   : UIImageView!
    @IBOutlet weak var lblUsername  : UILabel!
    @IBOutlet weak var lblComment   : UILabel!
    @IBOutlet weak var lblInitials  : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblInitials.setRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(comment: CommentData) {
        lblUsername.text = comment.userId?.name ?? ""
        lblComment.text  = comment.content ?? ""
        lblInitials.text = comment.userId?.name?.initials()
    }
    
}
