//
//  TaskDetailsAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 17/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class TaskDetailsAdapter: NSObject {
    
    
    weak var detailsTableView     : UITableView!
    var taskDetailVM              = TaskDetailVM()
    
    var assigneeSection           = 0
    var dueDateSection            = 1
    var reminderSection           = 2
    var subtaskSection            = 3
    var notesSection              = 4
    var commentsSection           = 5
    
    
    init(tableView: UITableView, fetchedData:[String], viewModel: TaskDetailVM) {
        super.init()
        
        taskDetailVM = viewModel
        
        tableView.registerNibs(from: taskConstants.table.cells)
        tableView.registerNib(from: SubtaskHeader.self)
        
        detailsTableView = tableView
        detailsTableView.backgroundColor = AppTheme.lightGrayBG()
        detailsTableView.keyboardDismissMode = .onDrag
        
        detailsTableView.configure(self)
    }
    
    public func reloadAdapter() {
        self.detailsTableView.reloadData()
    }
}

extension TaskDetailsAdapter : UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let controller = UIApplication.topViewController() as? TaskDetailVC
        controller?.hidePicker()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskConstants.table.sections
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == subtaskSection {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SubtaskHeader.identifier) as? SubtaskHeader {
                headerView.taskDetailVM = taskDetailVM
                return headerView
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return taskConstants.table.sectionHeights[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == commentsSection {
            return taskDetailVM.comments.value.count
        }
        if section == subtaskSection {
            return taskDetailVM.subTasks.value.count
        }
        if section == assigneeSection && taskDetailVM.selectedCategory?.synced ?? false {
            return 0
        }
        
        // assignee field for shared lists only
        
//        if taskDetailVM.selectedCategory?.owner?.id == Persistence.shared.currentUserID && CategoryListingVM.sharedUsers.count <= 1 && section == 0 {
//            return 0
//        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == commentsSection && taskDetailVM.comments.value[indexPath.row].userId?.id == Persistence.shared.currentUserID) || indexPath.section == subtaskSection {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            Utility.deleteCallBack = {
                
                if indexPath.section == self.subtaskSection {
                    self.taskDetailVM.deleteSubtask(subtaskId: self.taskDetailVM.subTasks.value[indexPath.row].id ?? "", index: indexPath.row)
                    
                } else if indexPath.section == self.commentsSection {
                    if self.taskDetailVM.comments.value[indexPath.row].userId?.id == Persistence.shared.currentUserID {
                        self.taskDetailVM.deleteComment(commentId: self.taskDetailVM.comments.value[indexPath.row].id ?? "", index: indexPath.row)
                    } else {
                        Utility.showSnackBar(msg: authStr, icon: nil)
                    }
                }
            }
            Utility.showDeletion()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == assigneeSection {
            if let _ = taskDetailVM.taskData.value.assigneeId?.id {
                guard let cell : AssignedCell = tableView.dequeue(cell: AssignedCell.self) else { return UITableViewCell() }
                cell.populate(viewModel: taskDetailVM)
                return cell
                
            } else {
                guard let cell : AssigneeCell = tableView.dequeue(cell: AssigneeCell.self) else { return UITableViewCell() }
                cell.populateData(viewModel: taskDetailVM)
                return cell
            }
            
        } else if indexPath.section == dueDateSection {
            guard let cell : DueDateCell = tableView.dequeue(cell: DueDateCell.self) else { return UITableViewCell() }
            cell.populate(viewModel: taskDetailVM)
            return cell
            
        } else if indexPath.section == reminderSection {
            guard let cell : ReminderCell = tableView.dequeue(cell: ReminderCell.self) else { return UITableViewCell() }
            cell.populate(viewModel: taskDetailVM)
            return cell
            
        } else if indexPath.section == subtaskSection {
            guard let cell : SubtaskCell = tableView.dequeue(cell: SubtaskCell.self) else { return UITableViewCell() }
            cell.populateData(viewModel: taskDetailVM, index: indexPath.row)
            
            return cell
            
        } else if indexPath.section == notesSection {
            guard let cell : NoteCell = tableView.dequeue(cell: NoteCell.self) else { return UITableViewCell() }
            cell.populateData(viewModel: taskDetailVM)
            return cell
            
        } else {
            guard let cell : CommentDetailCell = tableView.dequeue(cell: CommentDetailCell.self) else { return UITableViewCell() }
            cell.populateData(comment: taskDetailVM.comments.value[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return taskConstants.table.rowHeights[indexPath.section]
    }
    
}

extension TaskDetailsAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == assigneeSection {
            UIApplication.topViewController()?.navigateToMembers(viewModel: taskDetailVM)
        }
        
        if indexPath.section == dueDateSection || indexPath.section == reminderSection {
            tableView.deselectRow(at: indexPath, animated: true)
            taskDetailVM.pickerType = indexPath.section == dueDateSection ? .dueDate : .reminder
            let controller = UIApplication.topViewController() as? TaskDetailVC
            controller?.showPicker(section: indexPath.section)
        }
    }
}
