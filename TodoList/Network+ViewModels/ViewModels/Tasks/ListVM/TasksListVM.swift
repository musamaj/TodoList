//
//  TasksListVM.swift
//  TodoList
//
//  Created by Usama Jamil on 26/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreData
import SwiftQueue


class TasksListVM: NSObject {

    
    // MARK:- Bindable Properties
    
    
    var taskData            : Dynamic<TaskData> = Dynamic.init(TaskData())
    var tasks               = Dynamic.init([TaskData]())
    var completedTasks      = Dynamic.init([TaskData]())
    var uncompletedTasks    = Dynamic.init([TaskData]())
    
    var taskItems           = [TaskEntity]()
    
    static var selectedCategory     : CategoryData?
    var showCompleted               = Dynamic.init(Bool())
    
    var tasksByCategory             = [String: [TaskData]]()
    var categoryKeys                = [String]()
    
    static var query                : String?
    var parentVC                    : UIViewController?
    
    
    func filterData() {
        
        TaskEntity.filterKeyword    = TasksListVM.query
        self.taskItems              = TaskEntity.getTasks(true, sortAscending: false, byQuery: true)
        let taskObjects             = TaskData().fromNSManagedObject(tasks: self.taskItems)
        
        for task in taskObjects {
            if let categoryId = task.listId {
                
                var tasksArr = self.tasksByCategory[categoryId]
                
                if tasksArr?.count ?? 0 > 0 {
                    tasksArr?.append(task)
                    self.tasksByCategory[categoryId] = tasksArr
                    
                } else {
                    self.tasksByCategory[categoryId] = [task]
                }
                
            }
        }
        
        self.categoryKeys = self.tasksByCategory.keys.sorted()
        self.tasks.value  = taskObjects
        
        print("tasks by category are: \(self.tasksByCategory.keys)")
    }
    
    
    func fethcDummyTasks() {
        
        let task = TaskData()
        task.descriptionField = App.messages.dummyTask
        
        self.uncompletedTasks.value = [task, task]
        //task.done = true
        self.completedTasks.value   = [task]
        
    }
    
    func setSelectedCategory(listId: String) {
        NSCategory.fetchId = listId
        let items = NSCategory.getCategories(byPredicate: true)
        if items.count > 0 {
            let cats = CategoryData().fromNSManagedObject(categories: items)
            TasksListVM.selectedCategory = cats[0]
        }
    }
    
    
    // MARK:- Network Calling
    
    
    func update(data: CategoryData) {
        TasksListVM.selectedCategory = data
        
        let controller = UIApplication.topViewController() as? TaskListingVC
        controller?.navigationItem.title = data.name
    }
    
    func updateData(data: TaskData) {
        
        let index = self.tasks.value.firstIndex { (taskData) -> Bool in
            taskData.id == data.id
        }
        if let arrIndex = index {
            self.tasks.value[arrIndex] = data
        }
        self.filterTasks()
    }

    func listen(data: TaskData, action: String) {
        
        if TasksListVM.selectedCategory?.id == data.listId {
            if action == App.Events.taskCreated {
                self.tasks.value.insert(data, at: 0)
                self.filterTasks()
                TaskLoader.createTask(data: data)
                
                return
            }
            
            let index = self.tasks.value.firstIndex { (taskData) -> Bool in
                taskData.id == data.id
            }
            
            if let arrIndex = index {
                
                if action == App.Events.taskDeleted {
                    self.tasks.value.remove(at: arrIndex)
                    self.filterTasks()
                    TaskLoader.deleteTask(data: data)
                    
                } else if action == App.Events.taskUpdated {
                    self.tasks.value[arrIndex] = data
                    self.filterTasks()
                    TaskLoader.updateTask(data: data)
                }
            }
        }
    }
    
    func filterTasks() {
            
        uncompletedTasks.value = tasks.value.filter { (data) -> Bool in
            (data.done ?? true) == false
        }
        
        let completedOnes = tasks.value.filter { (data) -> Bool in
            (data.done ?? false) == true
        }
        
        completedTasks.value = completedOnes
    }
    
}


extension TasksListVM: taskUpdate {
    
    func didUpdated(data: TaskData) {
        self.updateData(data: data)
    }
    
}
