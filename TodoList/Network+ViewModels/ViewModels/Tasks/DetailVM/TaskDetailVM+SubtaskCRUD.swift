//
//  TaskDetailVM+SubtaskCRUD.swift
//  TodoList
//
//  Created by Usama Jamil on 19/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation



// MARK:- Subtask Api's



extension TaskDetailVM {
    
    func fetchSubtasks() {
        
        self.subtaskItems   = SubtaskEntity.getSubTasks(true, sortAscending: true, byTask: true)
        self.subTasks.value = SubtaskData().fromNSManagedObject(tasks: self.subtaskItems)
        subTaskLD.subtasks  = self.subTasks.value
        
        if self.subTasks.value.isEmpty {
            subTaskLD.fetchSubtasks()
        }
    }
    
    func addSubtask(params: [String: AnyObject]) {
        
        subtaskData                            = Dynamic.init(SubtaskData())
        subtaskData.value.id                   = UUID().uuidString
        subtaskData.value.createdAt            = Utility.getCurrentTimeStamp()
        subtaskData.value.descriptionField     = params[App.paramKeys.desc] as? String
        subtaskData.value.done                 = false
        
        let item = SubtaskEntity.saveSubTask(subtaskData.value)
        self.subtaskItems.append(item)
        self.subTasks.value.append(subtaskData.value)
        
        var param = subTaskLD.createParam(params: params)
        param[App.paramKeys.fetchID] = self.subtaskData.value.id
        
        JobFactory.scheduleJob(param: param, jobType: SubtaskCreationJob.type, id: subtaskData.value.id ?? "")
    }
    
    func updateSubtask(subtask: SubtaskData, params: [String: AnyObject]) {
        
        subtaskData = Dynamic.init(SubtaskData())
        self.subtaskData.value = subtask
        self.updateData(data: self.subtaskData.value)
        
        SubtaskEntity.fetchId = self.subtaskData.value.id
        SubtaskEntity.updateSubtask(self.subtaskData.value, true, false)
        
        var param = subTaskLD.updateParam(subtaskId: subtask.id ?? "", params: params)
        param[App.paramKeys.fetchID] = self.subtaskData.value.id
        
        JobFactory.scheduleJob(param: param, jobType: SubtaskUpdateJob.type, id: subtaskData.value.id ?? "")
    }
    
    func deleteSubtask(subtaskId: String, index: Int) {
        
        self.subTasks.value.removeAll(where: { (data) -> Bool in
            data.id == subtaskId
        })
        let item = self.subtaskItems.first { (entity) -> Bool in
            (entity.id == subtaskId || entity.serverId == subtaskId)
        }
        
        if let object = item {
            object.rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
        
        var param = subTaskLD.deleteParam(subtaskId: subtaskId)
        param[App.paramKeys.fetchID] = subtaskId
        
        JobFactory.scheduleJob(param: param, jobType: SubtaskDeletionJob.type, id: item?.id ?? "")
    }
    
}


extension TaskDetailVM {
    
    func handleSubtaskFetch() {
        self.subTasks.value = subTaskLD.subtasks
        
        SubtaskEntity.deleteByPredicate(entity: SubtaskEntity.identifier)
        SubtaskEntity.saveSubtasks(self.subTasks.value)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.subtaskItems = SubtaskEntity.getSubTasks()
        }
    }
    
}
