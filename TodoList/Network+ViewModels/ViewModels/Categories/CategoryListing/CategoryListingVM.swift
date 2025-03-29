//
//  CategoryListingVM.swift
//  TodoList
//
//  Created by Usama Jamil on 26/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import CoreData
import ObjectMapper
import SVProgressHUD


class CategoryListingVM: NSObject {

    
    // MARK:- Properties
    
    
    var categories      = Dynamic.init([CategoryData]())
    var changes         = Dynamic.init([GenericData]())
    var categoryItems   = [NSCategory]()
    
    static var sharedUsers         = [RegisterUser]()
    
    var categoryByFolders          = [String: [CategoryData]]()
    var folderKeys                 = [String]()
    
    
    override init() {
        super.init()
        
        categoryLD.delegate = self
    }
    
    func getCategories(indexPath: IndexPath)-> [CategoryData] {
        if indexPath.section < self.folderKeys.count {
            return self.categoryByFolders[self.folderKeys[indexPath.section]] ?? [CategoryData]()
        }
        
        return [CategoryData]()
    }
    
    func toggleExpand(section: Int) {
        self.categoryByFolders[self.folderKeys[section]]?[0].expanded  = !(self.categoryByFolders[self.folderKeys[section]]?[0].expanded ?? false)
    }
    
    
    // MARK:- Functions
    
    
    func fetchApproved() {
        
        let allCategories = NSCategory.getCategories()
        self.categoryItems  = allCategories.filter { (data) -> Bool in
            data.accepted == true
        }
        
        self.categories.value = CategoryData().fromNSManagedObject(categories: self.categoryItems)
        
        categoryLD.categories = self.categories.value
    }
    
    func fetchData(fetchServerChanges : Bool = true) {
        
        if Persistence.shared.isAppAlreadyLaunchedForFirstTime {
            Persistence.shared.isAppAlreadyLaunchedForFirstTime = false
            Persistence.shared.refreshToken = Utility.getCurrentTimeStamp()
        }
        
        // fetch from core data
        self.categoryItems = NSCategory.getCategories()
        categoryLD.categories = CategoryData().fromNSManagedObject(categories: self.categoryItems)
        
        self.groupCategories()
        
        if categoryLD.categories.isEmpty {
            categoryLD.fetchCategories()
        }
        
        print(" pending jobs are \(String(describing: JobFactory.queueManager?.jobCount()))")
        
        if fetchServerChanges {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                categoryLD.fetchChanges()
            }
        }
    
    }
    
    func groupCategories() {
        
        self.categoryByFolders.removeAll()
        
        for category in categoryLD.categories {
            
            if let folderId = category.parentFolder?.id {
                var categoriesArr = self.categoryByFolders[folderId]
                if categoriesArr?.count ?? 0 > 0 {
                    categoriesArr?.append(category)
                    self.categoryByFolders[folderId] = categoriesArr
                } else {
                    self.categoryByFolders[folderId] = [category]
                }
            } else if let categoryId = category.id {
                self.categoryByFolders[categoryId] = [category]
            }
        }
        
        self.folderKeys = self.categoryByFolders.keys.sorted()
        if self.folderKeys.count > 0 {
            let inboxKey = self.folderKeys.remove(at: self.folderKeys.count-1)
            self.folderKeys.insert(inboxKey, at: 0)
        }
        
        self.categories.value  = categoryLD.categories
        
    }
    
    
    func approveList(category: CategoryData, accepted: Bool) {
        
    }
    
    
    func delete(data: CategoryData) {
        
        let item = self.categoryItems.first { (entity) -> Bool in
            (entity.id == data.id || entity.serverId == data.id)
        }
        
        categoryLD.categories.removeAll { (data) -> Bool in
            data.id == item?.id || data.id == item?.serverId
        }
        
        self.groupCategories()
        
        if let object = item {
            object.rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
    
        //for offline case add operations to queue
        
        let param = categoryLD.deleteParam(data: data)
        JobFactory.scheduleJob(param: param, jobType: CategoryDeletionJob.type, id: item?.id ?? "")
    }
    
    func Update(data: CategoryData) {
        
        let index = categoryLD.categories.firstIndex { (catData) -> Bool in
            catData.id == data.id
        }
        if let arrIndex = index {
            categoryLD.categories[arrIndex] = data
        }
        
        self.groupCategories()
    }
    
    func Delete(data: CategoryData) {
        
        let index = categoryLD.categories.firstIndex { (catData) -> Bool in
            catData.id == data.id
        }
        if let arrIndex = index {
            categoryLD.categories.remove(at: arrIndex)
        }
        
        self.groupCategories()
    }
    
}



// MARK:- Response Handling



extension CategoryListingVM {
    
    func handleFetch() {
        
        PersistenceManager.sharedInstance.deleteAllRecords(entity: NSCategory.identifier)
        let inbox = CategoryData.addInbox()
        categoryLD.categories.insert(inbox, at: 0)
        self.groupCategories()
        
        NSCategory.saveCategories(categoryLD.categories)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.categoryItems = NSCategory.getCategories()
            SVProgressHUD.dismiss()
        }
    }
}


// MARK:- Sockets Delegate


extension CategoryListingVM: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .read {
            self.handleFetch()            
        }
    }
    
    func failure(type: responseTypes) {}
}
