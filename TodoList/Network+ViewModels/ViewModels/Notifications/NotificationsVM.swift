//
//  NotificationsVM.swift
//  TodoList
//
//  Created by Usama Jamil on 03/03/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit


enum NotificationTypes: String {
    case Completed
    case Joined
    case Created
    case Reminder
}

class NotificationData {
    
    var notifTypes : String = ""
    var notifyString : String = ""
    var actionString : String = ""
    
    func instance(type: String, notification: String, action: String)-> NotificationData {
        self.notifTypes = type
        self.notifyString = notification
        self.actionString = action
        
        return self
    }
    
}

class NotificationsVM: NSObject {

    var notifData = [NotificationData]()
    
    func fetchNotifications() {
        
        notifData.append(NotificationData().instance(type: NotificationTypes.Completed.rawValue, notification: "Azher Ashiq completed Groceries in Movies to watch & shared with other users.", action: "Groceries"))
        notifData.append(NotificationData().instance(type: NotificationTypes.Joined.rawValue, notification: "Usama Jamil joined your list Movies to Watch", action: "Movies to Watch"))
        notifData.append(NotificationData().instance(type: NotificationTypes.Created.rawValue, notification: "Azher Ashiq created Groceries in Movies to watch & shared with other users.", action: "Groceries"))
        notifData.append(NotificationData().instance(type: NotificationTypes.Reminder.rawValue, notification: "Need to create task for all projects & notify leads.", action: ""))

    }
    
}
