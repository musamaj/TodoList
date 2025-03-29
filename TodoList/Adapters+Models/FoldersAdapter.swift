//
//  FoldersAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 11/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class FoldersAdapter: NSObject {
    
    weak var foldersTableView        : UITableView!
    var viewModel                    = FoldersListingVM()
    
    
    init(tableView: UITableView, fetchedData:[String], viewmodel: FoldersListingVM) {
        super.init()
        
        viewModel = viewmodel
        
        tableView.registerNib(from: FolderDetailCell.self)
        tableView.registerNib(from: NewFolderCell.self)
        
        foldersTableView = tableView
        foldersTableView.backgroundColor = .white
        
        foldersTableView.estimatedRowHeight = App.tableCons.defaultHeight
        foldersTableView.delegate = self
        foldersTableView.dataSource = self
        foldersTableView.keyboardDismissMode = .onDrag
        foldersTableView.tableFooterView = UIView(frame: .zero)
        foldersTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: foldersTableView.frame.size.width, height: 0.01))
        
        foldersTableView.reloadData()
        
    }
    
    public func reloadAdapter() {
        self.foldersTableView.reloadData()
    }
}

extension FoldersAdapter : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.rowsCount()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : FolderDetailCell = tableView.dequeue(cell: FolderDetailCell.self) else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            return cell
        } else if indexPath.row == 1 {
            guard let cell : NewFolderCell = tableView.dequeue(cell: NewFolderCell.self) else { return UITableViewCell() }
            return cell
        }
        
        cell.lblFolderName.text = viewModel.getFolder(index: indexPath.row).name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CategoryStrs.tableCons.defaultHeight
    }
    
}

extension FoldersAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            FoldersEntity.selectedFolder = nil
            FoldersListingVM.selectedFolder = nil
            UIApplication.topViewController()?.pop()
        } else if indexPath.row != 1 {
            FoldersEntity.selectedFolder = viewModel.getFolderItem(index: indexPath.row)
            UIApplication.topViewController()?.pop()
        }
        
    }
}


extension FoldersAdapter {
    
    func actDone() {
        if let row = self.foldersTableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as? NewFolderCell {
            if let folderTitle = row.txtFolderName.text, !folderTitle.isEmpty {
                FoldersListingVM.selectedFolder = folderTitle
                UIApplication.topViewController()?.endEditing()
                UIApplication.topViewController()?.pop()
            } else {
                UIApplication.topViewController()?.endEditing()
            }
        }
    }
    
}
