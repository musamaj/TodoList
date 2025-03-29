//
//  AppConstants.swift
//  FanTazTech
//
//  Created by Muhammad Azher on 06/01/2018.
//  Copyright © 2018 Expertinsol. All rights reserved.
//


import UIKit
import SwiftyUserDefaults


struct App {
    
    static let arrThemes = [
                            [R.color.gradient1_top(),
                             R.color.gradient1_bottom()],
        
                            [R.color.gradient2_top(),
                             R.color.gradient2_bottom()],
                            
                            [R.color.gradient3_top(),
                             R.color.gradient3_bottom()],
                            
                            [R.color.gradient4_top(),
                             R.color.gradient4_bottom()],
                            
                            themes.theme1,
                            themes.theme2,
                            themes.theme3,
                            themes.theme4,
                            themes.theme5,
                            
                            R.color.bg_color1(),
                            R.color.bg_color2(),
                            R.color.bg_color3(),
                            UIColor.darkGray
                            ]
                            as [AnyObject]
    
    static let imgColors = [themes.theme1: UIColor.init(red: 179/255, green: 167/255, blue: 153/255, alpha: 1.0),
                            themes.theme2: UIColor.init(red: 187/255, green: 120/255, blue: 85/255, alpha: 1.0),
                            themes.theme3: UIColor.init(red: 5/255, green: 165/255, blue: 224/255, alpha: 1.0),
                            themes.theme4: UIColor.init(red: 212/255, green: 97/255, blue: 79/255, alpha: 1.0),
                            themes.theme5: UIColor.init(red: 5/255, green: 147/255, blue: 162/255, alpha: 1.0)]
    
    struct SDKKeys {
        static let googleId = "716644032646-781e09lq38fjo7q25ju7fbv05rtt1j07.apps.googleusercontent.com".localized()
    }
    
    struct themes {
        static let theme1 = "ic_theme1"
        static let theme2 = "ic_theme2"
        static let theme3 = "ic_theme3"
        static let theme4 = "ic_theme4"
        static let theme5 = "ic_theme5"
    }
    
    struct navTitles {
        static let todo         = "Tasks".localized()
        static let listCreation = "New List".localized()
        static let editList     = "Edit List".localized()
        static let foldersList  = "Choose a Folder".localized()
        static let membersList  = "Share".localized()
        static let profile      = "Account Details".localized()
        static let taskDetail   = "Task Details".localized()
        static let notes        = "Notes".localized()
        static let activities   = "Activities".localized()
    }
    
    struct alertKeys {
        static let renameFolder         = "Rename Folder".localized()
        static let ungroup              = "Ungroup".localized()
        static let cancel               = "Cancel".localized()
    }
    
    struct Constants {
        static let cellPadding   : CGFloat = 1
        static let fieldPadding  : CGFloat = 8
        static let defaultRadius : CGFloat = 8
        static let defaulttabbar : CGFloat = 60
        static let jobDelay      : Double = 0.0
        static let jobDelay1     : Double = 1.0
    }
    
    struct tableCons {
        static let defaultHeight : CGFloat = 50
        static let cellHeight   : CGFloat  = 60
        static let headerHeight : CGFloat = 60
        static let taskCell     : CGFloat  = 80
        static let estHeaderHeight : CGFloat = 50
        static let estRowHeight : CGFloat = 50

    }
    
    struct Validations {
        
        // validations strings
    
        static let requiredStr                         = "Please enter required fields".localized()
        static let usernameStr                         = "Please enter username".localized()
        static let firstNameStr                        = "Please enter first name".localized()
        static let lastNameStr                         = "Please enter last name".localized()
        static let emailStr                            = "Please enter email".localized()
        static let passwordStr                         = "Please enter password".localized()
        static let compareStr                          = "Passwords mismatch".localized()
        static let emailValidationStr                  = "Please enter valid email".localized()
        static let urlValidationStr                    = "Please enter valid url".localized()
        static let signInStr                           = "Have an account already? Sign In".localized()
        static let forgotStr                           = "Password reset details sent to your email".localized()
        static let listShared                          = "List Already shared".localized()
        static let noUsers                             = "Please invite users to assign task".localized()
    }
    
    struct dateFormats {
        /**
         * Date Patterns
         */
        let datePattern_Display_Time            = "HH:mm:ss"
        let datePattern_Display_TimeAM          = "hh:mm a"
        let datePattern_Display_DateAndTime     = "MMM dd, yyyy - hh:mm a"
        let datePattern_Display_Date            = "MM-dd-YYYY"
        let datePattern_Server                  = "MM-dd-yyyy"
        let pastDelivery_datePattern            = "dd-MM-yyyy"
        let pastDelivery_weekdatePattern        = "EEEE (dd-LLL-yyyy)"
        let datePattern_CompletedJob            = "yyyy-MM-dd hh:mm:ss"
        static let datePattern_task             = "E, d MMMM"
        static let datePattern_reminder         = "E d MMMM, h:mm a"
        static let utcFormat                    = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
    
    struct paramKeys {
        static let name                         = "name".localized()
        static let done                         = "done".localized()
        static let desc                         = "description".localized()
        static let note                         = "note".localized()
        static let assigneeId                   = "assigneeId".localized()
        static let dueDate                      = "dueDate".localized()
        static let limit                        = "limit".localized()
        static let comment                      = "content".localized()
        static let inviteEmail                  = "invitee_email".localized()
        static let listId                       = "listId".localized()
        static let list_id                      = "list_id".localized()
        static let taskId                       = "taskId".localized()
        static let folderId                     = "folderId".localized()
        static let subtaskId                    = "subtaskId".localized()
        static let subtask                      = "subtask".localized()
        static let commentStr                   = "comment".localized()
        static let commentId                    = "commentId".localized()
        static let listName                     = "listName".localized()
        static let userId                       = "userId".localized()
        static let Id                           = "id".localized()
        static let msg                          = "message".localized()
        static let error                        = "error".localized()
        static let data                         = "data".localized()
        static let body                         = "body".localized()
        static let auth                         = "auth_token".localized()
        static let fetchID                      = "fetchID".localized()
        static let timestamp                    = "timestamp".localized()
        static let unassigned                   = "Unassigned".localized()
        static let accepted                     = "accepted".localized()
    }
    
    struct placeholders {
        static let reminder                     = "Reminder".localized()
        static let dueDate                      = "Due date".localized()
        static let dueToday                     = "Today".localized()
        static let dueYesterday                 = "Yesterday".localized()
        static let dueTomorrow                  = "Tomorrow".localized()
        static let bgGradient                   = "bgGradient".localized()
        static let catInbox                     = "Inbox".localized()
    }
    
    struct barItemTitles {
        static let edit                         = "".localized()
        static let done                         = "Done".localized()
        static let cancel                       = "Cancel".localized()
        static let add                          = "Add".localized()
        static let added                        = "Added".localized()
        static let save                         = "Save".localized()
        static let delete                       = "Delete".localized()
        static let alert                        = "Alert!".localized()
        static let ok                           = "OK".localized()
        static let owner                        = "OWNER".localized()
        static let pending                      = "PENDING".localized()
    }
    
    struct toggleKeys {
        static let show                         = "SHOW COMPLETED TO-DOS"
        static let hide                         = "HIDE COMPLETED TO-DOS"
    }
    
    struct  messages {
        static let invite                       = "Invitation Sent"
        static let dueDate                      = "Please select valid due date"
        static let syncPending                  = "Data syncing is in progress"
        static let delWarning                   = "Are you sure you want to delete this?"
        static let revokeWarning                = "Your access has been revoked."
        static let alreadyExists                = "User already exists in invitees"
        static let dummyTask                    = "Preview to-do"
        static let remindStr                    = "Remind me at"
    }
    
    struct Events {
        
        // Folder CRUD
        static let createFolder                       = "createFolder"
        static let updateFolder                       = "updateFolder"
        static let getFolders                         = "getFolders"
        static let deleteFolder                       = "deleteFolder"
        
        
        // Category CRUD
        static let createList                       = "createList"
        static let updateList                       = "updateList"
        static let getLists                         = "getUserLists"
        static let deleteList                       = "deleteList"
        static let approveList                      = "acceptOrRejectAList"
        
        static let getListUsers                     = "getListUsers"
        static let unshareAList                     = "unshareAList"
        
        
        // Task CRUD
        static let createTask                       = "createTask"
        static let getTasks                         = "getListTasks"
        static let deleteTask                       = "deleteTask"
        static let updateTask                       = "updateTask"
        
        
        // Comments CRUD
        static let createComment                       = "createComment"
        static let getComments                         = "getTaskComments"
        static let deleteComment                       = "deleteComment"
        
        
        // Subtasks CRUD
        static let createSubtask                        = "createSubtask"
        static let getSubtasks                          = "getSubtasks"
        static let updateSubtask                        = "updateSubtask"
        static let deleteSubtask                        = "deleteSubtask"
        
        
        static let shareAList                           = "shareAList"
        
        
        // Category Listeners
        static let listDeleted                        = "listDeleted"
        static let listUpdated                        = "listUpdated"
        static let listShared                         = "listShared"
        static let listUnshared                       = "listUnshared"
        static let joinAList                          = "joinAList"
        
        
        // Task Listeners
        static let taskDeleted                        = "taskDeleted"
        static let taskUpdated                        = "taskUpdated"
        static let taskCreated                        = "taskCreated"
        
        
        // SubTask Listeners
        static let subTaskCreated                     = "subTaskCreated"
        static let subTaskDeleted                     = "subTaskDeleted"
        static let subTaskUpdated                     = "subTaskUpdated"
        
        
        // Comment Listeners
        static let commentCreated                     = "commentCreated"
        static let commentDeleted                     = "commentDeleted"
        static let commentUpdated                     = "commentUpdated"
        
    }
    
}


struct taskConstants {
    
    static let descriptionDefaultHeight : CGFloat = 40
    static let descriptionExpandPadding : CGFloat = 20
    static let maxExpandConstant        : CGFloat = 120
    
    struct table {
        
        static let sections = 6
        
        static let cells = [NoteCell.self, AssigneeCell.self, AssignedCell.self, DueDateCell.self, ReminderCell.self, SubtaskCell.self, CommentDetailCell.self]
        
        static let rowHeights : [CGFloat] = [60, 50, UITableView.automaticDimension, UITableView.automaticDimension, UITableView.automaticDimension, UITableView.automaticDimension]
        static let sectionHeights : [CGFloat] = [CGFloat.leastNormalMagnitude, CGFloat.leastNormalMagnitude, CGFloat.leastNormalMagnitude, UITableView.automaticDimension, CGFloat.leastNormalMagnitude, CGFloat.leastNormalMagnitude]
    }
    
}



/**
 * General Class singleton constants
 */

let userDefaults: UserDefaults = UserDefaults.standard
let notifCenter: NotificationCenter = NotificationCenter.default
let application = UIApplication.shared
let appDelegate = application.delegate as! AppDelegate
let appUtility = AppUtility.sharedInstance
let persistence = Persistence.shared



var baseUrl: String {
    
    var baseUrl = ""

    switch appMode {
        case .test:
            baseUrl = "https://todo-api-s63.herokuapp.com"
        case .production:
            baseUrl = "https://e6b5ec41.ngrok.io"
    }
    
    return baseUrl
}

var appBundle: String {
    
    var baseUrl = ""
    
    switch appMode {
    case .test:
        baseUrl = "com.square63.TodoSTG"
    case .production:
        baseUrl = ""
    }
    
    return baseUrl
}



struct CategoryStrs {
    static let create    = "Create List".localized()
    static let addMember = "Add People".localized()
    static let categories  = [0: ["Veggies", "Random"],
                              1: ["Important", "Maintenance"],
                              2: ["Notes", "Domestic", "Starred"],
                              3 : ["Create List"]]
    static let arrCategories = ["Veggies", "Random", "Starred", "Maintenance","Important", "Maintenance"]
    static let sections  = ["", "LIST MEMBERS", "", "FOLDER"]
    static let heights : [CGFloat]   = [0, 60, 0, 60]
    static var foldersArr = ["Grocery", "Miscellaneous"]
    static let todoStr      = "Add a to-do...".localized()
    
    static func getHeight(index: Int)-> CGFloat {
        return CategoryStrs.heights[index]
    }
    
    struct tableCons {
        static let defaultHeight : CGFloat = 50
        static let cellHeight   : CGFloat  = 60
        static let headerHeight : CGFloat = 60
    }
    
}


let contentTypeKey          = "Content-Type"
let jsonContentType         = "application/json"
let multipartContentType    = "multipart/form-data"
let urlEncodedContent       = "application/x-www-form-urlencoded"
let dataKey                 = "data"
let authHeaderKey           = "Authorization"
let authEmailKey            = "X-USER-EMAIL"
let perPageItems            = 10


/**
 * General constants
 */


let errorStr                            = "Something went wrong"
let authStr                             = "You're not authorized to perform this action"
let errorKey                            = "Error"
let successKey                          = "Success"
let defaultStr                          = "Default"
let refreshStr                          = "Pull to refresh"
let signInSubStr                        = "Sign In"
let cancelStr                           = "Cancel"
let createStr                           = "Create"
let updateStr                           = "Update"
let editStr                             = "Edit"
let backStr                             = "Back"
let addStr                              = "Add"
let youStr                              = "You"




/**
 * App keys
 */
let keyAuthToken                        = "appToken"
let keyAppTheme                         = "appTheme"
let keyFbUserInfo                       = "fbInfo"
let keyAmazonUserInfo                   = "amazonInfo"
let keyUserInfo                         = "userInfo"
let keyCurrentUserEmail                 = "currentUserEmail"
let keyIntroViewSeen                    = "isIntroViewSeen"
let keyAppUser                          = "appUser"
let keyExistingJob                      = "existingJob"


// Button titles
let buttonOK             = "OK"
let buttonCancel         = "Cancel"



// Persistence Keys

extension DefaultsKeys
{
    static let isAppAlreadyLaunchedForFirstTime = DefaultsKey<Bool?>("isAppAlreadyLaunchedForFirstTime")
    static let isUserAlreadyLoggedIn            = DefaultsKey<Bool?>("isUserAlreadyLoggedIn")
    static let isSignedUp                       = DefaultsKey<Bool?>("isSignedUp")
    static let isSocailLoggedIn                 = DefaultsKey<Bool?>("isSocialLoggedIn")
    
    static let currentUserID                    = DefaultsKey<String?>("currentUserID")
    static let currentUserUrlHash               = DefaultsKey<String?>("currentUserUrlHash")
    static let currentUserFirstName             = DefaultsKey<String?>("currentUserFirstName")
    static let currentUserLastName              = DefaultsKey<String?>("currentUserLastName")
    static let currentUserEmail                 = DefaultsKey<String?>("currentUserEmail")
    static let currentUserUsername              = DefaultsKey<String?>("currentUserUsername")
    static let currentUserLocation              = DefaultsKey<String?>("currentUserLocation")
    static let currentUserBio                   = DefaultsKey<String?>("currentUserBio")
    static let lastUserEmail                    = DefaultsKey<String?>("lastUserEmail")
    static let lastUserPassword                 = DefaultsKey<String?>("lastUserPassword")
    static let currentIsVerified                = DefaultsKey<Bool?>("currentIsVerified")
    static let accessToken                      = DefaultsKey<String?>("accessToken")
    static let deviceID                         = DefaultsKey<String?>("deviceID")
    static let refreshToken                     = DefaultsKey<String?>("refreshToken")
    
}



