//
//  SearchVC.swift
//  TodoList
//
//  Created by Usama Jamil on 29/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class SearchVC: BaseVC {

    
    // MARK:- Properties
    
    
    @IBOutlet weak var searchListing: UITableView!
    
    var searchesAdapter     : SearchesAdapter?
    let tasksVM             = TasksListVM()
    
    
    
    // MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        TasksListVM.query?.removeAll()
        self.viewConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavBar()
        self.bindViews()
    }
    
    override func viewDidLayoutSubviews() {
        AppTheme.setTheme(view: self.view)
    }
    
    func viewConfiguration() {
        
        searchesAdapter = SearchesAdapter.init(tableView: self.searchListing, viewModel: tasksVM)
    }
    
    func bindViews() {
        
        tasksVM.tasks.bind({ [weak self] (data) in
            self?.searchesAdapter?.reloadAdapter()
        })
    }
    
    func setNavBar() {
        
        leftImg = #imageLiteral(resourceName: "ic_searchbar")
        rightTitle = App.barItemTitles.cancel
        rightTint  = .white
        setNavigationBar(self)
        
        let txtSearch = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 30))
        txtSearch.backgroundColor = .clear
        txtSearch.tintColor       = .white
        txtSearch.font            = UIFont.systemFont(ofSize: 18, weight: .regular)
        txtSearch.textColor       = .white
        txtSearch.attributedPlaceholder = NSAttributedString(string: "Search..",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        txtSearch.delegate = self
        txtSearch.text     = TasksListVM.query
        
        txtSearch.becomeFirstResponder()
        
        let leftNavBarButton = UIBarButtonItem(customView:txtSearch)
        self.navigationItem.leftBarButtonItems = [leftButton, leftNavBarButton]
        
    }
    
    override func actRight() {
        self.pop()
    }
    
    override func actLeft() {
        // do something here
    }
    
}


extension SearchVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText:String = textField.text else { return true }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        self.tasksVM.tasksByCategory.removeAll()
        TasksListVM.query = updatedText
        self.tasksVM.filterData()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
