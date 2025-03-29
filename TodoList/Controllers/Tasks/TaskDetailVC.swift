//
//  TaskCreationVC.swift
//  TodoList
//
//  Created by Usama Jamil on 17/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class TaskDetailVC: UIViewController {

    
    // MARK:- OUTLETS & PROPERTIES
    
    
    @IBOutlet weak var detailsTableView         : UITableView!
    @IBOutlet weak var txtComment               : UITextView!
    @IBOutlet weak var txtDescription           : UITextView!
    @IBOutlet weak var bottomContainerHeight    : NSLayoutConstraint!
    @IBOutlet weak var topBarHeight             : NSLayoutConstraint!
    @IBOutlet weak var btnSend                  : UIButton!
    
    @IBOutlet var pickerView                    : UIView!
    @IBOutlet weak var datePicker               : UIDatePicker!
    
    
    var taskDetailAdapter : TaskDetailsAdapter?
    var taskDetailVM      = TaskDetailVM()
    
    
    // MARK:- LIFE CYCLE
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       self.viewConfig()
        
        taskDetailVM.fetchSubtasks()
        taskDetailVM.fetchComments()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppTheme.setNavBartheme(view: self.view)
        hideNav()
        taskDetailAdapter?.reloadAdapter()
        
        self.bindViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.hidePicker()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.textViewDidChange(txtDescription)
    }
    
    
    // MARK:- FUNCTIONS
    
    
    func viewConfig() {
        
        txtDescription.delegate = self
        txtDescription.returnKeyType = .done
        txtComment.delegate = self
        
        subTaskLD.delegate = taskDetailVM
        commentLD.delegate = taskDetailVM
        
        hideNav()
        
        self.txtDescription.text = self.taskDetailVM.taskData.value.descriptionField
        taskDetailAdapter = TaskDetailsAdapter.init(tableView: detailsTableView, fetchedData: [], viewModel: taskDetailVM)
    }
    
    func bindViews() {
        
        taskDetailVM.taskData.bind { [weak self] (data) in
            self?.txtDescription.text = self?.taskDetailVM.taskData.value.descriptionField
            self?.taskDetailAdapter?.reloadAdapter()
        }
        taskDetailVM.subTasks.bind { [weak self] (data) in
            //self?.taskDetailAdapter?.reloadAdapter()
            
            guard let self = self else { return }
            UIView.transition(with: self.detailsTableView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.detailsTableView.reloadData()
            }, completion: { (isCompleted) in

            })
            //self.detailsTableView.reloadSections(IndexSet.init(integer: 2), with: .fade)
            
        }
        taskDetailVM.subtaskData.bind { [weak self] (data) in
            self?.taskDetailAdapter?.reloadAdapter()
        }
        taskDetailVM.comments.bind { [weak self] (data) in
            self?.taskDetailAdapter?.reloadAdapter()
        }
        taskDetailVM.commentData.bind { [weak self] (data) in
            self?.btnSend.isUserInteractionEnabled = true
            self?.endEditing()
            self?.txtComment.text?.removeAll()
            self?.bottomContainerHeight.constant = taskConstants.descriptionDefaultHeight  + taskConstants.descriptionExpandPadding
            self?.taskDetailVM.comments.value.append(data)
            self?.taskDetailAdapter?.reloadAdapter()
        }
        
    }
    
    func param()-> [String: AnyObject] {
        return [App.paramKeys.desc      : txtDescription.text as AnyObject]
    }
    
    
    // MARK:- IBACTIONS
    
    
    @IBAction func actRemoveDate(_ sender: Any) {
        self.removeDate()
        self.hidePicker()
    }
    
    @IBAction func actAddDate(_ sender: Any) {
        self.addDate()
        self.hidePicker()
    }
    
    
    @IBAction func actSend(_ sender: Any) {
        
        if !txtComment.text.isEmpty {
            btnSend.isUserInteractionEnabled = false
            taskDetailVM.comment(params: [App.paramKeys.comment : txtComment.text as AnyObject])
        }
    }
    
    @IBAction func actBack(_ sender: Any) {
        self.pop()
    }
    
}


extension TaskDetailVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let expandedHeight = textView.getExpandedHeight(taskConstants.maxExpandConstant)
        if textView == txtComment {
            bottomContainerHeight.constant = expandedHeight + taskConstants.descriptionExpandPadding
        } else {
            topBarHeight.constant = expandedHeight + taskConstants.descriptionExpandPadding
        }
    }
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            if textView == txtDescription && txtDescription.isValid() {
                taskDetailVM.taskData.value.descriptionField = txtDescription.text
                taskDetailVM.updateTask(params: param())
            }
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        btnSend.alpha = 1
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        btnSend.alpha = 0
    }
    
}


// MARK:- Date picker methods


extension TaskDetailVC {
    
    func showPicker(section: Int) {
        self.datePicker.datePickerMode = section == 1 ? .date : .dateAndTime
        self.datePicker.date = taskDetailVM.getSelectedDate()
        self.datePicker.minimumDate = Date()
        Animations.showMenu(menuView: self.pickerView, controller: self, tabBarHeight: 0)
    }
    
    func hidePicker() {
        Animations.hideMenu(menuView: self.pickerView, controller: self, tabBarHeight: 0)
    }
    
    func removeDate() {
        if taskDetailVM.pickerType == .dueDate {
            if let row = self.detailsTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as? DueDateCell {
                if let _ = taskDetailVM.taskData.value.dueDate {
                    row.removeDate()
                }
            }
        } else {
            if let row = self.detailsTableView.cellForRow(at: IndexPath.init(row: 0, section: 2)) as? ReminderCell {
                if let _ = taskDetailVM.taskData.value.remindAt {
                    row.removeDate()
                }
            }
        }
    }
    
    func isDateValid()-> Bool {
        if datePicker.date > Date() || Calendar.current.isDateInToday(datePicker.date) {
            return true
        } else {
            Utility.showSnackBar(msg: App.messages.dueDate, icon: nil)
            return false
        }
    }
    
    func addDate() {
        if taskDetailVM.pickerType == .dueDate {
            if let row = self.detailsTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as? DueDateCell {
                if self.isDateValid() {
                    row.addDate(date: datePicker.date)
                }
            }
        } else {
            if let row = self.detailsTableView.cellForRow(at: IndexPath.init(row: 0, section: 2)) as? ReminderCell {
                if self.isDateValid() {
                    row.addDate(date: datePicker.date)
                }
            }
        }
    }
}
