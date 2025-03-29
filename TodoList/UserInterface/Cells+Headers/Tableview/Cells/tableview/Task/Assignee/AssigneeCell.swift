//
//  AssigneeCell.swift
//  TodoList
//
//  Created by Usama Jamil on 02/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class AssigneeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(viewModel: TaskDetailVM) {
        self.hideSeparator()
    }
    
}
