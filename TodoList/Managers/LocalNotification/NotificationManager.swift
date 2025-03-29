//
//  LocalNotificationManager.swift
//  TodoList
//
//  Created by Usama Jamil on 06/05/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import Foundation
import UserNotifications
import ObjectMapper


enum dataTypes: String {
    case list
    case task
    case subtask
    case comment
}


struct NotificationType {
    var id:String
    var title:String
    var datetime:DateComponents
}


class NotificationManager : NSObject
{
    static let shared = NotificationManager()
    var notifications = [NotificationType]()
    
    var category      = CategoryData()
    var task          = TaskData()
    var killedState   = false
    
    
    func setDelegate() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    func listScheduledNotifications()
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            
            for notification in notifications {
                print(notification)
            }
        }
    }
    
    func cancellAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func unscheduleNotifications(identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    private func requestAuthorization()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    func createAndSchedule(id: String, name: String, date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        self.notifications = [NotificationType.init(id: id, title: name, datetime: components)]
        self.schedule()
    }
    
    func schedule()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }
    
    private func scheduleNotifications()
    {
        for notification in notifications
        {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.sound    = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)
            
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                
                guard error == nil else { return }
                
                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
    
    
    // Register for push notifications
    
    func registerForPushNotification(){
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @objc func handleEvent() {
        if Persistence.shared.isUserAlreadyLoggedIn {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                // Code you want to be delayed
                self.navigate()
            }
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func navigate() {
        UIApplication.topViewController()?.navigateToTaskDetail(task: self.task, category: self.category)
    }
    
    func getDataFromDB(taskId: String)-> TaskData {
        TaskEntity.fetchId  = taskId
        let taskItems       = TaskEntity.getTasks(byPredicate: true)
        let tasks           = TaskData().fromNSManagedObject(tasks: taskItems)
        if tasks.count > 0 {
            TaskEntity.selectedTask = taskItems[0]
            if let categoryItem = tasks[0].parentCategory {
                let categories   = CategoryData().fromNSManagedObject(categories: [categoryItem])
                self.category    = categories[0]
            }
            return tasks[0]
        }
        
        self.category = CategoryData()
        return TaskData()
    }
    
    func addObserver(id: String) {
        if Persistence.shared.isUserAlreadyLoggedIn {
            self.task = self.getDataFromDB(taskId: id)
            if UIApplication.shared.applicationState == .active {
                guard let _ = UIApplication.topViewController() as? TaskDetailVC else {
                    self.handleEvent()
                    return
                }
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(handleEvent), name: UIApplication.didBecomeActiveNotification, object: nil)
            }
        }
    }
    
}


extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    
    
    // delegate is called when the app starts from a tapped notification.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let id = response.notification.request.identifier
        print("Received notification with ID = \(id)")
        
        self.addObserver(id: id)
        completionHandler()
    }
    
    
    // recieve notifications when app is running
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
        Persistence.shared.deviceID = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
}
