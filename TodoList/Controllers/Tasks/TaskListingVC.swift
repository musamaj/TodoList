//
//  TaskListingVC.swift
//  TodoList
//
//  Created by Usama Jamil on 16/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import PopupKit


class TaskListingVC: BaseVC {

    
    // MARK:- Outlets & Properties
    
    
    @IBOutlet weak var tasksTableView   : UITableView!
    
    var tasksAdapter                    : TasksAdapter?
    var tasksVM                         = TasksListVM()
    var moreActions                     = MoreActions()
    @IBOutlet weak var btnShare         : UIButton!
    @IBOutlet weak var tabView          : UIView!
    @IBOutlet weak var tabViewHeight    : NSLayoutConstraint!
    
    var moreActionsToggle               = false
    
    // MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        shouldReturn = false
        self.viewConfiguration()
        self.taskFieldResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if moreActionsToggle {
            moreActionsToggle.toggle()
            Animations.toggleMenu(menuView: self.moreActions, controller: self, tabBarHeight: 0, toggle: moreActionsToggle, subViewIndex: 1)
        }
    }
    
    // MARK:- Overiding methods
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MembersListVM.shared.sharedListId = TasksListVM.selectedCategory?.id
        self.setDefaults(TasksListVM.selectedCategory?.name ?? App.navTitles.todo, rightStr: App.barItemTitles.edit)
        self.setNavigationBar(self)
        AppTheme.setNavBartheme()
        
        tasksVM.fetchData()
        
        self.bindViews()
        self.moreActions = MoreActions.fromNib()
        self.moreActions.setTheme()
        
    }
    
    override func viewDidLayoutSubviews() {
        AppTheme.setTheme(view: self.view)
        AppTheme.setNavBartheme(view: self.tabView)
    }
    
    override func actRight() {
        
        let item = self.navigationItem.rightBarButtonItem
        
        if item?.title == App.barItemTitles.add {
            self.taskCreation()
        } else if item?.title == App.barItemTitles.done {
            self.endEditing()
        }
    }
    
    override func actLeft() {
        if let _ = tasksVM.parentVC as? CategoryCreationVC {
            Utility.backTwo(newSelf: self)
        } else {
            self.pop()
        }
    }
    
    
    // MARK:- Functions
    
    
    func viewConfiguration() {
        
        if (TasksListVM.selectedCategory?.synced ?? false) {
            self.tabView.alpha = 0
        }
        taskLD.delegate = tasksVM
        self.moreActions = MoreActions.fromNib()
        self.tasksAdapter = TasksAdapter.init(tableView: self.tasksTableView, fetchedData: [""], viewModel: tasksVM)
        
    }
    
    func taskFieldResponder() {
        if let row = self.tasksTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? NewTaskCell {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
                row.txtTitle.becomeFirstResponder()
            }
        }
    }
    
    func bindViews() {
        
        
        tasksVM.completedTasks.bind { [weak self] (data) in
            
            guard let self = self else { return }
            UIView.transition(with: self.tasksTableView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.tasksTableView.reloadData()
                //self.tasksTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }, completion: { (isCompleted) in

            })
        }
        

        tasksVM.showCompleted.bind { [weak self] (data) in
            
            guard let self = self else { return }
            UIView.transition(with: self.tasksTableView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.tasksTableView.reloadData()
                self.tasksTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                
            }, completion: { (isCompleted) in
    
            })
            
        }
    }
    
    func taskCreation() {
        if let cell = tasksTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? NewTaskCell, let title = cell.txtTitle.text {
            cell.txtTitle.text?.removeAll()
            tasksVM.create(taskName: title)
        }
    }
    
    func invite() {
        let invitePopup : InvitePopup = InvitePopup.fromNib()
        let view = PopupView.init(contentView: invitePopup)
        view.show()
        
        MembersListVM.shared.inviteEmail.bind { (data) in
            invitePopup.lblEmail.text?.removeAll()
            view.dismiss(animated: true)
        }
    }
    
    
    // MARK:- IBActions
    

    @IBAction func actShare(_ sender: Any) {

        if let category = TasksListVM.selectedCategory {
            MembersListVM.shared.selectedCategory = category
        }
        self.navigateToMembers(viewModel: TaskDetailVM())
    }
    
    @IBAction func actMore(_ sender: Any) {
        
        guard let btnMore = (sender as? UIButton) else { return }
        btnMore.isUserInteractionEnabled = false
        moreActionsToggle.toggle()
        
        var tabConstant = App.Constants.defaulttabbar
        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR || DeviceType.IS_IPHONE_XS_MAX {
            tabConstant = App.Constants.defaulttabbar+30
        }
        
        Animations.toggleMenu(menuView: self.moreActions, controller: self, tabBarHeight: tabConstant, toggle: moreActionsToggle, subViewIndex: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
            (sender as? UIButton)?.isUserInteractionEnabled = true
        }
    }
    
}
