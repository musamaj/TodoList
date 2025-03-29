//
//  DueDateCell.swift
//  TodoList
//
//  Created by Usama Jamil on 22/01/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit

class DueDateCell: UITableViewCell {

    @IBOutlet weak var lblDate      : UILabel!
    @IBOutlet weak var imgDate      : UIImageView!
    @IBOutlet weak var btnRemove    : UIButton!
    
    var taskDetailVM                = TaskDetailVM()
    
    
    
    // MARK:- Life Cycle
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnRemove.alpha = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK:- Functions
    
    
    func param()-> [String: AnyObject] {
        return [App.paramKeys.dueDate      : taskDetailVM.taskData.value.dueDate as AnyObject]
    }
    
    func populate(viewModel: TaskDetailVM) {
        
        taskDetailVM     = viewModel
        if let date = taskDetailVM.taskData.value.dueDate {
            if let dateType = Utility.date(strDate: date, format: App.dateFormats.utcFormat) {
                self.enableAttributes(date: dateType)
            }
            
        } else {
            self.disableAttributes()
        }
    }
    
    func addDate(date: Date) {
        
        self.enableAttributes(date: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = App.dateFormats.utcFormat
        let dateStr = formatter.string(from: date)
        
        taskDetailVM.taskData.value.dueDate = dateStr
        taskDetailVM.updateTask(params: self.param())
        
    }
    
    func removeDate() {
        
        self.disableAttributes()
        
        taskDetailVM.taskData.value.dueDate = nil
        taskDetailVM.updateTask(params: self.param())
    }
    
    func setTheme(duePassed: Bool) {
        
        if duePassed {
            self.lblDate.textColor = AppTheme.themeRedColor()
            self.imgDate.tintColor = AppTheme.themeRedColor()
        } else {
            self.lblDate.textColor = AppTheme.lightBlue()
            self.imgDate.tintColor = AppTheme.lightBlue()
        }
    }
    
    
    func enableAttributes(date: Date) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = App.dateFormats.datePattern_task
        var dateStr = formatter.string(from: date)
        
        if Calendar.current.isDateInToday(date) {
            dateStr = App.placeholders.dueToday
            self.setTheme(duePassed: false)
            
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
        self.lblDate.text = "Due \(dateStr)"
    }
    
    
    func disableAttributes() {
        
        btnRemove.alpha = 0
        self.lblDate.textColor = .lightGray
        self.imgDate.tintColor = .lightGray
        self.lblDate.text = App.placeholders.dueDate
    }
    
    
    // MARK:- IBActions
    
    
    @IBAction func actRemove(_ sender: Any) {
        self.removeDate()
    }
    
}
