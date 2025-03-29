//
//  TaskDetailVM.swift
//  TodoList
//
//  Created by Usama Jamil on 07/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import ObjectMapper


protocol taskUpdate:class {
    func didUpdated(data: TaskData)
}

enum PickerTypes {
    case reminder
    case dueDate
}

class TaskDetailVM: NSObject {

    
    // MARK:- Bindable Properties
    
    
    var taskData            = Dynamic.init(TaskData())
    var subtaskData         = Dynamic.init(SubtaskData())
    var subTasks            = Dynamic.init([SubtaskData]())
    
    var commentData         = Dynamic.init(CommentData())
    var comments            = Dynamic.init([CommentData]())
    
    var subtaskItems        = [SubtaskEntity]()
    var commentItems        = [CommentEntity]()
    
    var selectedCategory    : CategoryData?
    static var selectedTask : TaskData?
    
    static var delegate     : taskUpdate?
    var pickerType          : PickerTypes = .dueDate
    
    
    
    // MARK:- Notes Param
    
    
    func noteParam()-> [String: AnyObject] {
        return [App.paramKeys.note : self.taskData.value.note as AnyObject]
    }
    
    func getSelectedDate()-> Date {
        if self.pickerType == .dueDate {
            if let date = self.taskData.value.dueDate {
                if let dateType = Utility.date(strDate: date, format: App.dateFormats.utcFormat) {
                    return dateType
                }
            }
        } else {
            if let date = self.taskData.value.remindAt {
                return date
            }
        }
        return Date()
    }
    
    
    // MARK:- Update Task
    
    
    func listen(data: TaskData, action: String) {
        
        if selectedCategory?.id == data.listId {
            
            if action == App.Events.taskUpdated {
                self.taskData.value = data
                TaskDetailVM.delegate?.didUpdated(data: data)
            }
        }
    }
    
    func listen(data: SubtaskData, action: String) {
        
        if self.taskData.value.id == data.taskId {
            
            if action == App.Events.subTaskCreated {
                self.subTasks.value.append(data)
                SubtaskLoader.createSubtask(data: data)
                return
            }
            
            let index = self.subTasks.value.firstIndex { (taskData) -> Bool in
                taskData.id == data.id
            }
            
            if let arrIndex = index {
                
                if action == App.Events.subTaskDeleted {
                    self.subTasks.value.remove(at: arrIndex)
                    SubtaskLoader.deleteSubtask(data: data)
                    
                } else if action == App.Events.subTaskUpdated {
                    self.subTasks.value[arrIndex] = data
                    SubtaskLoader.updateSubtask(data: data)
                }
            }
        }
    }
    
    func listen(data: CommentData, action: String) {
        
        if self.taskData.value.id == data.taskId {
            
            if action == App.Events.commentCreated {
                self.comments.value.append(data)
                CommentsLoader.createComment(data: data)
                return
            }
            
            let index = self.comments.value.firstIndex { (commentData) -> Bool in
                commentData.id == data.id
            }
            
            if let arrIndex = index {
                
                if action == App.Events.commentDeleted {
                    self.comments.value.remove(at: arrIndex)
                    CommentsLoader.deleteComment(data: data)
                    
                } else if action == App.Events.commentUpdated {
                    self.comments.value[arrIndex] = data
                    CommentsLoader.updateComment(data: data)
                }
            }
        }
    }
    
    func updateTask(params: [String: AnyObject], delay: TimeInterval = 0.0) {
        
        var param = [App.paramKeys.listId   : selectedCategory?.id as AnyObject,
                     App.paramKeys.taskId   : taskData.value.id as AnyObject,
                     App.paramKeys.body     : params as AnyObject
        ]
        
        TaskEntity.fetchId = self.taskData.value.id
        TaskEntity.updateTask(self.taskData.value, true, false)
        
        TaskDetailVM.delegate?.didUpdated(data: self.taskData.value)
        self.taskData.value = self.taskData.value
        
        param[App.paramKeys.fetchID] = self.taskData.value.id as AnyObject?
        JobFactory.scheduleJob(param: param, jobType: TaskUpdateJob.type, id: self.taskData.value.id ?? "", delay: delay)
        
    }
    
    func updateData(data: SubtaskData) {
        let index = self.subTasks.value.firstIndex { (taskData) -> Bool in
            taskData.id == data.id
        }
        if let arrIndex = index {
            self.subTasks.value[arrIndex] = data
        }
    }
    
}


extension TaskDetailVM: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .commentRead {
            self.handleCommentsFetch()
            
        } else if type == .subtaskRead {
            self.handleSubtaskFetch()
            
        }
    }
    
    func failure(type: responseTypes) {}
}
