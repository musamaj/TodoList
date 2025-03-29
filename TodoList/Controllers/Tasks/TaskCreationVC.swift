//
//  TaskCreationVC.swift
//  TodoList
//
//  Created by Usama Jamil on 20/03/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit

class TaskCreationVC: UIViewController {

    
    // MARK:- IBOutlets
    
    
    @IBOutlet weak var txtTaskTitle         : UITextField!
    @IBOutlet weak var categoriesTableView  : UITableView!
    @IBOutlet weak var tableViewHeight      : NSLayoutConstraint!
    @IBOutlet weak var bottomBarSpacing     : NSLayoutConstraint!
    @IBOutlet weak var selectedCategorySpacing: NSLayoutConstraint!
    @IBOutlet weak var datePicker           : UIDatePicker!
    @IBOutlet var pickerView                : UIView!
    @IBOutlet weak var btnDone              : UIButton!
    @IBOutlet weak var btnDate              : UIButton!
    @IBOutlet weak var imgCategory          : UIImageView!
    @IBOutlet weak var lblCategoryTitle     : UILabel!
    @IBOutlet weak var navBarView           : UIView!
    
    
    // MARK:- Properties
    
    
    var categoriesAdapter                   : CategorySelectionAdapter?
    var categorylistVM                      = CategoryListingVM()
    var taskCreationVM                      = TasksListVM()
    var taskDetailVM                        = TaskDetailVM()
    
    var topPadding                          : CGFloat = 0
    var keyboardHeight                      : CGFloat = 0
    
    var taskDueDate                         : Date?
    
    
    // MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setSafeAreaMargins()
        txtTaskTitle.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        categorylistVM.fetchApproved() //fetchData(fetchServerChanges: false)
        
        self.txtTaskTitle.becomeFirstResponder()
        if categorylistVM.categoryItems.count > 0 {
            self.setSelectedCategory(index: 0)
            self.lblCategoryTitle.text = categorylistVM.categories.value[0].name
        }
        self.categoriesAdapter = CategorySelectionAdapter.init(tableView: self.categoriesTableView, VM: categorylistVM)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppTheme.setNavBartheme(view: self.navBarView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    
    // MARK:- Functions
    
    
    func setSafeAreaMargins() {
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            //topPadding = safeFrame.minY
            topPadding = window.frame.maxY - safeFrame.maxY
        }
    }
    
    func showPicker() {
        
        self.datePicker.date = Date()
        
        if let date = taskDetailVM.taskData.value.dueDate {
            if let dateType = Utility.date(strDate: date, format: App.dateFormats.utcFormat) {
                self.datePicker.date = dateType
                btnDate.tintColor = AppTheme.lightBlue()
            }
        } else {
            btnDate.tintColor = .lightGray
        }

        
        self.pickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.keyboardHeight+topPadding)
        UIView.animate(withDuration: 0.5) {
            self.bottomBarSpacing.constant = -(self.keyboardHeight-60)
        }
        self.datePicker.minimumDate = Date()
        Animations.showMenu(menuView: self.pickerView, controller: self, tabBarHeight: 0)
    }
    
    
    func setSelectedCategory(index: Int) {
        self.categoriesTableView.alpha = 0
        
        NSCategory.selectedCategory = categorylistVM.categoryItems[index]
        TasksListVM.selectedCategory = categorylistVM.categories.value[index]
        taskDetailVM.selectedCategory = categorylistVM.categories.value[index]
        self.lblCategoryTitle.text = categorylistVM.categories.value[index].name
    }
    
    func param()-> [String: AnyObject] {
        return [App.paramKeys.dueDate      : taskDetailVM.taskData.value.dueDate as AnyObject]
    }
    
    func setDueDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = App.dateFormats.utcFormat
        let dateStr = formatter.string(from: datePicker.date)
        taskDetailVM.taskData.value.dueDate = dateStr
    }
    
    
    // MARK:- IBActions
    
    
    @IBAction func actPicker(_ sender: Any) {
        self.endEditing()
        self.showPicker()
    }
    
    @IBAction func actDone(_ sender: Any) {
        self.endEditing()
        self.pop()
        
        if (btnDone.titleLabel?.text == App.barItemTitles.add) {
            taskCreationVM.create(taskName: txtTaskTitle.text ?? "")
            
            if let _ = taskDetailVM.taskData.value.dueDate {
                taskDetailVM.taskData.value = taskCreationVM.taskData.value
                self.setDueDate()
                taskDetailVM.updateTask(params: self.param())
            }
        }
        
    }

    @IBAction func actShowCategories(_ sender: Any) {
        
        if categorylistVM.categoryItems.count > 0 {
            self.endEditing()
            Animations.hideMenu(menuView: self.pickerView, controller: self, tabBarHeight: 0)
            self.categoriesTableView.alpha = 1
        } else {
            Utility.showSnackBar(msg: "Please create some categories first", icon: nil)
        }
    }
    
    
    @IBAction func actRemoveDate(_ sender: Any) {
        self.txtTaskTitle.becomeFirstResponder()
        Animations.hideMenu(menuView: self.pickerView, controller: self, tabBarHeight: 0)
        taskDetailVM.taskData.value.dueDate = nil
        btnDate.tintColor = .lightGray
    }
    
    @IBAction func actAddDate(_ sender: Any) {
       
        if datePicker.date > Date() || Calendar.current.isDateInToday(datePicker.date) {
            self.txtTaskTitle.becomeFirstResponder()
            Animations.hideMenu(menuView: self.pickerView, controller: self, tabBarHeight: 0)
            self.setDueDate()
            btnDate.tintColor = AppTheme.lightBlue()
            
        } else {
            btnDate.tintColor = .lightGray
            Utility.showSnackBar(msg: App.messages.dueDate, icon: nil)
        }
    }
    
    
}


// MARK:- Keyboard & textfield Observer


extension TaskCreationVC {
    
    @objc func editingChanged(_ textField: UITextField) {
        
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let title       = txtTaskTitle.text, !title.isEmpty, categorylistVM.categoryItems.count > 0
            else {
                btnDone.setTitle(App.barItemTitles.done, for: .normal)
                return
        }
        btnDone.setTitle(App.barItemTitles.add, for: .normal)
    }
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {
        
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - (topPadding)//self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        self.keyboardHeight = keyboardHeight
        UIView.animate(withDuration: 0.5) {
            self.bottomBarSpacing.constant = -keyboardHeight
        }
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        
        UIView.animate(withDuration: 0.5) {
            self.bottomBarSpacing.constant = 0.0
        }
    }
    
}
