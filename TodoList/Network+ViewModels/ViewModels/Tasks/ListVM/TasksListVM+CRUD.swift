//
//  TasksListVM+CRUD.swift
//  TodoList
//
//  Created by Usama Jamil on 14/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation


// MARK:- Handle Schedular


extension TasksListVM {
    
    func fetchData() {
        
        self.taskItems      = TaskEntity.getTasks(true, sortAscending: false, byCategory: true)
        self.tasks.value    = TaskData().fromNSManagedObject(tasks: self.taskItems)
        taskLD.tasks        = self.tasks.value
        
        if self.tasks.value.isEmpty {
            let param = taskLD.fetchParam()
            taskLD.fetchTasks(param: param)
        }
        
        self.filterTasks()

    }
    
    func create(taskName: String) {
        
        taskData                            = Dynamic.init(TaskData())
        taskData.value.id                   = UUID().uuidString
        taskData.value.createdAt            = Utility.getCurrentTimeStamp()
        taskData.value.descriptionField     = taskName
        taskData.value.done                 = false
        
        let item = TaskEntity.saveTask(taskData.value)
        self.taskItems.insert(item, at: 0)
        
        // set value to pop
        self.taskData.value = taskData.value
        self.tasks.value.insert(taskData.value, at: 0)
        self.filterTasks()
        
        self.onlineCalls(taskName: taskName)
    }
    
    func update(taskId: String, check: Bool) {
        
        let task = self.tasks.value.first(where: { (data) -> Bool in
            data.id == taskId
        })
        
        taskData = Dynamic.init(TaskData())
        self.taskData.value = task ?? TaskData()
        self.taskData.value.done = check
        self.updateData(data: self.taskData.value)
        
        TaskEntity.fetchId = self.taskData.value.id
        TaskEntity.updateTask(self.taskData.value, true, false)
        //self.filterTasks()
        
        var param = taskLD.updateParam(taskId: taskId, check: check)
        param[App.paramKeys.fetchID] = self.taskData.value.id
        
        JobFactory.scheduleJob(param: param, jobType: TaskUpdateJob.type, id: self.taskData.value.id ?? "")
        
        
        let item = self.taskItems.first { (entity) -> Bool in
            (entity.id == taskData.value.id || entity.serverId == taskData.value.id)
        }
        
        TaskEntity.selectedTask = item
        let subtasks = SubtaskEntity.getSubTasks(byTask: true)
        for subtask in subtasks {
            subtask.done = check
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
        
        //}
    }
    
    func delete(id: String) {
        
        self.tasks.value.removeAll(where: { (data) -> Bool in
            data.id == id
        })
        let item = self.taskItems.first { (entity) -> Bool in
            entity.id == id || entity.serverId == id
        }
        
        if let object = item {
            object.rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
        
        self.filterTasks()
        
        var param = taskLD.deleteParam(id: id)
        param[App.paramKeys.fetchID] = id
        
        JobFactory.scheduleJob(param: param, jobType: TaskDeletionJob.type, id: id)
    }
    
    func onlineCalls(taskName: String) {
        
        TaskEntity.fetchId = self.taskData.value.id
        var param = taskLD.createParam(taskName)
        param[App.paramKeys.fetchID] = self.taskData.value.id
        
        JobFactory.scheduleJob(param: param, jobType: TaskCreationJob.type, id: self.taskData.value.id ?? "")
    }
    
}



extension TasksListVM {
    
    func handleFetch() {
        
        self.tasks.value = taskLD.tasks
        self.filterTasks()
        
        TaskEntity.deleteByPredicate(entity: TaskEntity.identifier)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            TaskEntity.saveTasks(self.tasks.value)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.taskItems = TaskEntity.getTasks()
        }
    }
}



// MARK:- Sockets Delegate


extension TasksListVM: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .read {
            self.handleFetch()
        }
    }
    
    func failure(type: responseTypes) {}
}
