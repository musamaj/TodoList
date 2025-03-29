//
//  CategorySectionsAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 11/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import PopupKit


class CategorySectionsAdapter: NSObject {
    
    
    // MARK:- Properties
    
    
    weak var categorySections        : UITableView!
    var parentVC                    : UIViewController?
    var memberCells                 = [ 0 : TitleCell.self,
                                        1 : MemberCell.self,
                                        2 : NewMemberCell.self,
                                        3 : FolderCell.self
                                        ]
    let extraRow                    = 1
    var viewModel              = CategoryCreationVM()
    
    
    
    
    // MARK:- Initialization
    
    
    init(tableView: UITableView, viewModel: CategoryCreationVM, controller: UIViewController?) {
        super.init()
        
        parentVC        = controller
        self.viewModel  = viewModel
        
        tableView.registerNib(from: TitleCell.self)
        tableView.registerNib(from: MemberCell.self)
        tableView.registerNib(from: NewMemberCell.self)
        tableView.registerNib(from: FolderCell.self)
        
        categorySections = tableView
        categorySections.backgroundColor = AppTheme.lightBG()
        categorySections.estimatedRowHeight = App.tableCons.estRowHeight
        categorySections.delegate = self
        categorySections.dataSource = self
        categorySections.tableFooterView = UIView(frame: .zero)
        categorySections.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: categorySections.frame.size.width, height: 0.01))
        
        categorySections.reloadData()
    }
    
    public func reloadAdapter() {
        self.categorySections.reloadData()
    }
}



// MARK:- Tableview Datasource methods



extension CategorySectionsAdapter : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let _ = viewModel.categoryData.value.id {
            return 4
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = TitleHeader()
        title.viewConfiguration(title: CategoryStrs.sections[section])
        return title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CategoryStrs.getHeight(index: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 1 {
            return self.viewModel.categoryUsers.value.count + extraRow      // for members section
        }
        
        if section == 2 {
            if (viewModel.isCategoryEmpty())  {
                return 1
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let customCell   = memberCells[indexPath.section]
        
        guard let cell : ParentSectionCell = tableView.dequeue(cell: customCell ?? UITableViewCell.self) else { return UITableViewCell() }
        cell.populateData(viewModel: self.viewModel, indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return App.tableCons.cellHeight
    }
}




// MARK:- Tableview Delegate methods




extension CategorySectionsAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 3 {
            (parentVC as? CategoryCreationVC)?.navigateToFolders()
        } else if indexPath.section == 2 {
            (parentVC as? CategoryCreationVC)?.inviteAndBind()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 1 && indexPath.row == 0 && (viewModel.categoryData.value.owner?.id == Persistence.shared.currentUserID) {
            return false
        }
        
        if indexPath.section == 1 && (viewModel.categoryData.value.owner?.id == Persistence.shared.currentUserID) {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            
            if (viewModel.categoryData.value.owner?.id == persistence.currentUserID && indexPath.row == 0) || (viewModel.categoryData.value.owner?.id == viewModel.categoryUsers.value[indexPath.row-extraRow].id) {
                
                Utility.showSnackBar(msg: authStr, icon: nil)
                return
            }
            
            Utility.deleteCallBack = {
                self.viewModel.unshare(userID: self.viewModel.categoryUsers.value[indexPath.row-self.extraRow].id ?? "")
            }
            Utility.showDeletion()
            
        }
    }
    
}
