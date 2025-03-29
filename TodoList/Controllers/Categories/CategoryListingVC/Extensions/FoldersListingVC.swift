//
//  FoldersListingVC.swift
//  TodoList
//
//  Created by Usama Jamil on 11/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class FoldersListingVC: BaseVC {

    
    // MARK:- IBOutlets
    
    
    @IBOutlet weak var foldersTableView: UITableView!
    
    var foldersAdapter : FoldersAdapter?
    var foldersVM      = FoldersListingVM()
    
    
    // MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.viewConfiguration()
        self.bindViews()
        foldersVM.fetchFolders()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK:- Functions
    
    
    func viewConfiguration() {
        self.setDefaults(App.navTitles.foldersList, rightStr: "")
        self.setNavigationBar(self)
        
        self.foldersAdapter = FoldersAdapter.init(tableView: self.foldersTableView, fetchedData: [""], viewmodel: foldersVM)
    }
    
    override func actRight() {
        
        if self.navigationItem.rightBarButtonItem?.title == App.barItemTitles.done {
            self.foldersAdapter?.actDone()
        }
    }
    
    override func actLeft() {
        self.pop()
    }
    
    func bindViews() {
        
        foldersVM.folders.bind { [weak self] (data) in
            self?.foldersAdapter?.reloadAdapter()
        }
        
    }

}
