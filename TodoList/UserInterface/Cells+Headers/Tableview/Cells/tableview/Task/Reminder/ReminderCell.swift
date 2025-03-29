//
//  ReminderCell.swift
//  TodoList
//
//  Created by Usama Jamil on 07/05/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {

    @IBOutlet weak var imgReminder  : UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnRemove    : UIButton!
    @IBOutlet weak var backroundView: UIView!
    
    var taskDetailVM                = TaskDetailVM()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func populate(viewModel: TaskDetailVM) {
        
        taskDetailVM     = viewModel
        if let date = taskDetailVM.taskData.value.remindAt {
            self.enableAttributes(date: date)
        } else {
            self.disableAttributes()
        }
    }
    
    func scheduleReminder() {
        
        if let name = taskDetailVM.taskData.value.descriptionField, let date = taskDetailVM.taskData.value.remindAt {
            let id = taskDetailVM.taskData.value.localId ?? taskDetailVM.taskData.value.id ?? ""
            NotificationManager.shared.createAndSchedule(id: id, name: name, date: date)
        }
    }
    
    func updateTask() {
        TaskEntity.fetchId = taskDetailVM.taskData.value.id
        TaskEntity.updateTask(taskDetailVM.taskData.value, true, false)
    }
    
    func addDate(date: Date) {
        self.enableAttributes(date: date)
        taskDetailVM.taskData.value.remindAt = date
        self.scheduleReminder()
        self.updateTask()
    }
    
    func removeDate() {
        self.disableAttributes()
        taskDetailVM.taskData.value.remindAt = nil
        let id = taskDetailVM.taskData.value.localId ?? taskDetailVM.taskData.value.id ?? ""
        NotificationManager.shared.unscheduleNotifications(identifiers: [id])
        self.updateTask()
    }
    
    func setTheme(duePassed: Bool) {
        
        if duePassed {
            self.lblTitle.textColor = AppTheme.themeRedColor()
            self.imgReminder.tintColor = AppTheme.themeRedColor()
        } else {
            self.lblTitle.textColor = AppTheme.lightBlue()
            self.imgReminder.tintColor = AppTheme.lightBlue()
        }
    }
    
    
    func enableAttributes(date: Date) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = App.dateFormats.datePattern_reminder
        let dateVal = formatter.string(from: date)
        
        let dateArr = dateVal.split(separator: ",")
        
        if dateArr.count > 1 {
            
            var dateStr = String(dateArr[0])
            let timeStr = String(dateArr[1])
            
            if Calendar.current.isDateInToday(date) {
                dateStr = App.placeholders.dueToday
                if date < Date() {
                    self.setTheme(duePassed: true)
                } else {
                    self.setTheme(duePassed: false)
                }
                
                
            } else if Calendar.current.isDateInYesterday(date) {
                dateStr = App.placeholders.dueYesterday
                self.setTheme(duePassed: true)
                
            } else if Calendar.current.isDateInTomorrow(date) {
                dateStr = App.placeholders.dueTomorrow
                self.setTheme(duePassed: false)
                
            } else {
                if date < Date() {
                    self.setTheme(duePassed: true)
                } else {
                    self.setTheme(duePassed: false)
                }
            }
            
            btnRemove.alpha = 1
            self.lblTitle.text = "\(App.messages.remindStr)\(timeStr) \n\(dateStr)"
            
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }
    }
    
    
    func disableAttributes() {
        btnRemove.alpha = 0
        self.lblTitle.textColor = .lightGray
        self.imgReminder.tintColor = .lightGray
        self.lblTitle.text = App.placeholders.reminder
    }

    
    @IBAction func actRemove(_ sender: Any) {
        self.removeDate()
    }
    
}
