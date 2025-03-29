//
//	CommentData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper



class UserData : NSObject,Mappable{
    
    var id : String?
    var name : String?
    var email : String?
    
    class func newInstance(map: Map) -> Mappable?{
        return CommentData()
    }
    required init?(map: Map){}
    override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        name <- map["name"]
        email <- map["email"]
        
    }
    
}



class CommentData : NSObject, NSCoding, Mappable{

	var v : Int?
	var id : String?
	var content : String?
    var changeStreamCreatedAt : String?
	var createdAt : String?
	var taskId : String?
	var updatedAt : String?
	var userId : UserData?
    var userName : String?
    var parentTask : TaskEntity?


	class func newInstance(map: Map) -> Mappable?{
		return CommentData()
	}
	required init?(map: Map){}
    override init(){}

	func mapping(map: Map)
	{
		v <- map["__v"]
		id <- map["_id"]
		content <- map["content"]
        changeStreamCreatedAt <- map["changeStreamCreatedAt"]
		createdAt <- map["createdAt"]
		taskId <- map["taskId"]
		updatedAt <- map["updatedAt"]
		userId <- map["userId"]
        userName <- map["name"]
		
	}
    
    func initWithParams(params: [String: AnyObject])-> CommentData {
        
        let comment                            = CommentData()
        comment.id                             = UUID().uuidString
        comment.createdAt                      = Utility.getCurrentTimeStamp()
        comment.content                        = params[App.paramKeys.comment] as? String
        
        let userData                           = UserData()
        userData.id                            = Persistence.shared.currentUserID
        userData.name                          = Persistence.shared.currentUserUsername
        userData.email                         = Persistence.shared.currentUserEmail
        
        comment.userId                         = userData
        
        return comment
    }


    func fromGenericModel(generic: EntityData?)-> CommentData {
        
        let data                        = CommentData()
        
        data.id                         = generic?.id
        data.createdAt                  = generic?.createdAt
        data.content                    = generic?.content
        data.updatedAt                  = generic?.updatedAt
        data.taskId                     = generic?.taskId
        
        let userData                    = UserData()
        userData.id                     = generic?.userId?.id
        userData.name                   = generic?.userId?.name
        userData.email                  = generic?.userId?.email
        
        data.userId                     = userData
        
        return data
    }
    
    func fromNSManagedObject(comments: [CommentEntity])-> [CommentData] {
        
        var arrTasks = [CommentData]()
        
        for task in comments {
            
            let data                        = CommentData()
            
            data.id                         = task.id
            if let id = task.serverId {
                data.id             = id
            }
            data.createdAt                  = task.createdAt
            data.content                    = task.content
            data.updatedAt                  = task.updatedAt
            data.taskId                     = task.taskId
            
            let userData                    = UserData()
            userData.id                     = task.userId
            userData.name                   = task.username
            userData.email                  = task.email
            
            data.userId                     = userData
            
            arrTasks.append(data)
        }
        
        return arrTasks
    }
    

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         v = aDecoder.decodeObject(forKey: "__v") as? Int
         id = aDecoder.decodeObject(forKey: "_id") as? String
         content = aDecoder.decodeObject(forKey: "content") as? String
         createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
         taskId = aDecoder.decodeObject(forKey: "taskId") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
         userId = aDecoder.decodeObject(forKey: "userId") as? UserData
         userName = aDecoder.decodeObject(forKey: "name") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if v != nil{
			aCoder.encode(v, forKey: "__v")
		}
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if content != nil{
			aCoder.encode(content, forKey: "content")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "createdAt")
		}
		if taskId != nil{
			aCoder.encode(taskId, forKey: "taskId")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updatedAt")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "userId")
		}
        if userName != nil{
            aCoder.encode(userName, forKey: "name")
        }

	}

}
