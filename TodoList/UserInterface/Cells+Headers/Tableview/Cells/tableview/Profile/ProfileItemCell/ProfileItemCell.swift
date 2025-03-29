//
//  ProfileItemCell.swift
//  TodoList
//
//  Created by Usama Jamil on 31/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class ProfileItemCell: UITableViewCell {

    
    @IBOutlet weak var imgProfileItem   : UIImageView!
    @IBOutlet weak var lblItemTitle     : UILabel!
    @IBOutlet weak var imgDetails       : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(img: UIImage?, title: String) {
        imgProfileItem.image = img
        lblItemTitle.text    = title
    }
    
    func themeChanges(indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.row == 0 {
            self.imgDetails.image = nil
            AppTheme.setNavBartheme(view: self.imgDetails)
            self.imgDetails.setRounded(cornerRadius: 4, width: 0, color: .clear)
            
        } else {
            self.imgDetails.image = #imageLiteral(resourceName: "ic_arrowRight")
            self.imgDetails.backgroundColor = .clear
        }
        
    }
    
}
