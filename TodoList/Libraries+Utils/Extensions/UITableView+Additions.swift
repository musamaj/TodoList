//
//  UITableView+Additions.swift
//  AppStructure
//
//  Created by Muhammad Azher on 18/01/2018.
//  Copyright © 2018 FahidAttique. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func configure(_ parent: NSObject) {
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = App.tableCons.estRowHeight
        self.estimatedSectionFooterHeight = UITableView.automaticDimension
        self.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.delegate = parent as? UITableViewDelegate
        self.dataSource = parent as? UITableViewDataSource
        self.tableFooterView = UIView(frame: .zero)
        self.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0.01))
        self.reloadData()
    }
    
    func registerNib(from cellClass: UITableViewCell.Type) {
        let identifier = cellClass.identifier
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func registerNibs(from cells: [UITableViewCell.Type]) {
        for cellClass in cells {
            let identifier = cellClass.identifier
            register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
    }

    func registerNib(from headerFooterClass: UITableViewHeaderFooterView.Type) {
        let identifier = headerFooterClass.identifier
        register(UINib(nibName: identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    
    
    func registerCell(from cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func dequeue<T: Any>(cell: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: cell.identifier) as? T
    }

    func dequeue<T: Any>(headerFooter: UITableViewHeaderFooterView.Type) -> T? {
        
        return dequeueReusableHeaderFooterView(withIdentifier: headerFooter.identifier) as? T
    }
    
    func reloadTableWithoutScrolling() {
        
        let contentOffset = self.contentOffset
        self.reloadData()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
    }

}






extension UITableView {
    
    func addRefreshControl(_ refresher: UIRefreshControl, withSelector selector:Selector) {
        
        refresher.addTarget(nil, action: selector, for: .valueChanged)
        if #available(iOS 10.0, *) {
            refreshControl = refresher
        } else {
            addSubview(refresher)
        }
    }
    
    func addRefreshControl(viewcontroller:UIViewController)
    {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        self.refreshControl?.addTarget(viewcontroller, action: #selector(viewcontroller.refreshData), for: .valueChanged)
        
        self.addSubview(refreshControl!)
    }
    
    func stopRefreshControl() {
        self.refreshControl?.endRefreshing()
    }
    
}


extension UITableViewCell {
    
    func hideSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
    }
    
    func showSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


extension UIResponder {

    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}

extension UITableViewCell {
    
    var tableView: UITableView? {
        return next(UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}


extension UITableViewHeaderFooterView {
    
    var tableView: UITableView? {
        return next(UITableView.self)
    }
}
