//
//  UserProfileAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 31/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class UserProfileAdapter: NSObject {
    
    weak var profileTableView     : UITableView!
    var parentVC                  : AccountDetailsVC?
    
    
    init(tableView: UITableView, fetchedData:[String], controller: AccountDetailsVC?) {
        super.init()
        
        parentVC = controller
        
        tableView.registerNib(from: ProfileHeader.self)
        tableView.registerNib(from: ProfileItemCell.self)
        
        profileTableView = tableView
        //profileTableView.backgroundColor = UIColor.white
        
        profileTableView.rowHeight = UITableView.automaticDimension
        profileTableView.estimatedRowHeight = App.tableCons.estRowHeight
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.tableFooterView = UIView(frame: .zero)
        profileTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.size.width, height: 0.01))
        
        profileTableView.reloadData()
    }
    
    public func reloadAdapter() {
        self.profileTableView.reloadData()
    }
}

extension UserProfileAdapter : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileCons.sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileHeader.identifier) as? ProfileHeader {
                headerView.populateData()
                return headerView
            }
        } else {
            let title = TitleHeader()
            title.viewConfiguration(title: ProfileCons.sections[section])
            return title
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ProfileCons.sectionHeights[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ProfileCons.data[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : ProfileItemCell = tableView.dequeue(cell: ProfileItemCell.self) else { return UITableViewCell() }
        let image = ProfileCons.images[indexPath.section]?[indexPath.row]
        cell.populateData(img: image, title: ProfileCons.data[indexPath.section]?[indexPath.row] ?? "")
        cell.themeChanges(indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension UserProfileAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == IndexPath.init(row: 0, section: 1) {
            
            if JobFactory.queueManager?.jobCount() == 0 {
                appUtility.logout()
                parentVC?.logoutNavigation()
                UIApplication.shared.statusBarView?.backgroundColor = .clear
            } else {
                Utility.deleteCallBack = {
                    appUtility.logout()
                    self.parentVC?.logoutNavigation()
                }

                Utility.showWarning("Unsynced data will be deleted!, \(JobFactory.queueManager?.jobCount()) jobs left", true)
                //Utility.showSnackBar(msg: App.messages.syncPending, icon: nil)
            }
        } else if indexPath == IndexPath.init(row: 0, section: 2) {
            UIApplication.topViewController()?.navigateToThemes()
        }
    }
}
