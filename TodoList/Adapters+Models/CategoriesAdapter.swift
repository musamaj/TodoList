//
//  CategoriesAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 04/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class CategoriesAdapter: GenericRefreshControl {
    
    weak var categoriesTableView     : UITableView!
    
    var categoryCells               = [CategoryCell.self, NewCategoryCell.self]
    var viewModel                   = CategoryListingVM()
    
    init(tableView: UITableView, fetchedData:[String], viewmodel: CategoryListingVM) {
        super.init()
        
        viewModel = viewmodel
        categoriesTableView = tableView
        
        
        categoriesTableView.registerNib(from: ListAcceptenceCell.self)
        categoriesTableView.registerNib(from: CategoryCell.self)
        categoriesTableView.registerNib(from: NewCategoryCell.self)
        categoriesTableView.registerNib(from: CategoryHeader.self)
        
        categoriesTableView.backgroundColor = UIColor.white
        
        categoriesTableView.rowHeight = UITableView.automaticDimension
        categoriesTableView.estimatedRowHeight = App.tableCons.estRowHeight
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.tableFooterView = UIView(frame: .zero)
        categoriesTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: categoriesTableView.frame.size.width, height: 0.01))
        
        //self.configureDragDrop()
        
        //self.setupRefresh()
        categoriesTableView.reloadData()
    }
    
    func setupRefresh() {
        
        self.pageRequest = {
        }
        self.pullRequest = {
            Persistence.shared.isAppAlreadyLaunchedForFirstTime = true
            self.viewModel.fetchData()
        }
        self.setupRefreshControls(adapter: self, tableView: categoriesTableView)
    }
    
    public func reloadAdapter() {
        self.categoriesTableView.reloadData()
    }
}

extension CategoriesAdapter : UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let viewController = UIApplication.topViewController() as? CategoryListingVC {
            viewController.view.endEditing(true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (viewModel.folderKeys.count) + 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == viewModel.folderKeys.count {
            return false
        }
        
        let categories = viewModel.getCategories(indexPath: indexPath)
        if categories.count > 0 {
            if categories[0].owner?.id == Persistence.shared.currentUserID {
                return true
            }
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            Utility.deleteCallBack = {
                let categories = self.viewModel.getCategories(indexPath: indexPath)
                if categories.count > 0 {
                    self.viewModel.delete(data: categories[indexPath.row])
                }
            }
            Utility.showDeletion()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let categories = self.viewModel.getCategories(indexPath: IndexPath.init(row: 0, section: section))
        if section < viewModel.folderKeys.count && categories.count > 0 && viewModel.folderKeys[section] == categories[0].parentFolder?.id {
            
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoryHeader.identifier) as? CategoryHeader {
                headerView.viewConfiguration(adapter: self, section: section)
                return headerView
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        let categories = self.viewModel.getCategories(indexPath: IndexPath.init(row: 0, section: section))
        if section < viewModel.folderKeys.count && categories.count > 0 && viewModel.folderKeys[section] == categories[0].parentFolder?.id {
            
            return App.tableCons.estHeaderHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let categories = self.viewModel.getCategories(indexPath: IndexPath.init(row: 0, section: section))
        if section < viewModel.folderKeys.count && categories.count > 0 {
            if !(categories[0].expanded) && viewModel.folderKeys[section] == categories[0].parentFolder?.id {
                return 0
            }
        }
        
        let rows = section == viewModel.folderKeys.count ? 1 : categories.count
        return rows
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categories = self.viewModel.getCategories(indexPath: indexPath)
        
        if indexPath.section < viewModel.folderKeys.count && !(categories[indexPath.row].accepted) {
            guard let cell : ListAcceptenceCell = tableView.dequeue(cell: ListAcceptenceCell.self) else { return UITableViewCell() }
            cell.lblOwner.tag = indexPath.row
            cell.lblInitial.tag = indexPath.section
            cell.populateData()
            return cell
        }
        
        var cellIndex = 0
        if indexPath.section == viewModel.folderKeys.count {
            cellIndex = 1
        }
        
        guard let cell : ParentCategoryCell = tableView.dequeue(cell: categoryCells[cellIndex]) else { return UITableViewCell() }
        let title = indexPath.section == viewModel.folderKeys.count ? CategoryStrs.create : categories[indexPath.row].name
        cell.populateData(title: title ?? "", index: indexPath)
        
        if indexPath.section < viewModel.folderKeys.count && categories.count > 0 {
            if (categories[0].expanded) && viewModel.folderKeys[indexPath.section] == categories[0].parentFolder?.id {
                cell.backgroundColor = .groupTableViewBackground
            } else {
                cell.backgroundColor = .clear
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let categories = self.viewModel.getCategories(indexPath: indexPath)
        
        if indexPath.section < viewModel.folderKeys.count && !(categories[indexPath.row].accepted) {
            return 50
        } else {
            return UITableView.automaticDimension
        }
    }
    
}

extension CategoriesAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let categories = self.viewModel.getCategories(indexPath: indexPath)
        
        if indexPath.section == viewModel.folderKeys.count {
            TasksListVM.selectedCategory = nil
            UIApplication.topViewController()?.navigateToCategoryCreation()
            
        } else if indexPath.section < viewModel.folderKeys.count && !(categories[indexPath.row].accepted) {
            // do nothing
            
        } else {
            let item = viewModel.categoryItems.first { (entity) -> Bool in
                (entity.id == categories[indexPath.row].id || entity.serverId == categories[indexPath.row].id)
            }
            FoldersEntity.selectedFolder = item?.folder
            UIApplication.topViewController()?.navigateToTasksListing(category: categories[indexPath.row], item: item)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        self.handleDragOperations(sIndexpath: sourceIndexPath, dIndexpath: destinationIndexPath)
        if let movedObject = viewModel.categoryByFolders[viewModel.folderKeys[sourceIndexPath.section]]?[sourceIndexPath.row] {
            viewModel.categoryByFolders[viewModel.folderKeys[sourceIndexPath.section]]?.remove(at: sourceIndexPath.row)
            viewModel.categoryByFolders[viewModel.folderKeys[destinationIndexPath.section]]?.insert(movedObject, at: destinationIndexPath.row)
        }
    }
    
    
    func handleDragOperations(sIndexpath: IndexPath, dIndexpath: IndexPath) {
        
        if let movedObject = viewModel.categoryByFolders[viewModel.folderKeys[sIndexpath.section]]?[sIndexpath.row] {
            
            if let arrCategories = viewModel.categoryByFolders[viewModel.folderKeys[dIndexpath.section]], arrCategories.count > 0 {
                if let destObject = viewModel.categoryByFolders[viewModel.folderKeys[dIndexpath.section]]?[0] {
                    
                    if viewModel.folderKeys[dIndexpath.section] == destObject.parentFolder?.id {
                        self.moveToDestinationFolder(movedObject: movedObject, destObject: destObject)
                    } else if viewModel.folderKeys[sIndexpath.section] == movedObject.parentFolder?.id {
                        self.moveToDestinationFolder(movedObject: movedObject, destObject: nil)
                    }
                }
            }
        }

    }
    
    func moveToDestinationFolder(movedObject: CategoryData?, destObject: CategoryData?) {
        
        let item = viewModel.categoryItems.first { (entity) -> Bool in
            (entity.id == movedObject?.id ?? "" || entity.serverId == movedObject?.id ?? "")
        }
        item?.folder = destObject?.parentFolder
        PersistenceManager.sharedInstance.mergeWithMainContext()
    }
    
}
