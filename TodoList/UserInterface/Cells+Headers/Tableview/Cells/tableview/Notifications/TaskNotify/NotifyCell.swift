//
//  TaskNotifyCell.swift
//  TodoList
//
//  Created by Usama Jamil on 02/03/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit


class NotifyCell: UITableViewCell {

    @IBOutlet weak var lblInitials      : UILabel!
    @IBOutlet weak var lblDetail        : UILabel!
    @IBOutlet weak var lblTime          : UILabel!
    @IBOutlet weak var imgCheckBox      : UIImageView!
    @IBOutlet weak var imgNotification  : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblInitials.setRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(viewModel: NotificationsVM, index: Int) {
        
        // attributes will be changed on different types of notifications
        
        let data = viewModel.notifData[index]
        lblDetail.text = data.notifyString
        lblDetail.halfTextBold(fullText: data.notifyString, changeText: data.actionString)
        
        if data.notifTypes == NotificationTypes.Reminder.rawValue {
            lblInitials.backgroundColor = .red
            lblInitials.text = ""
            imgNotification.image = #imageLiteral(resourceName: "ic_reminder")
            imgNotification.alpha = 1
            imgCheckBox.image = #imageLiteral(resourceName: "ic_reminder")
            imgCheckBox.tintColor = .red
            
        } else if data.notifTypes == NotificationTypes.Completed.rawValue {
            imgCheckBox.image = #imageLiteral(resourceName: "ic_check")
            imgCheckBox.tintColor = AppTheme.green2()
            
        }  else if data.notifTypes == NotificationTypes.Joined.rawValue {
            imgCheckBox.image = #imageLiteral(resourceName: "ic_joined")
            imgCheckBox.tintColor = AppTheme.green2()
        } else  {
            lblInitials.backgroundColor = AppTheme.lightgreen()
            lblInitials.text = "M"
            imgNotification.alpha = 0
            imgCheckBox.image = #imageLiteral(resourceName: "ic_uncheck")
            imgCheckBox.tintColor = .gray
        }
    }
    
}
