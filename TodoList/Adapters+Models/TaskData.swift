//
//	TaskData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class TaskData : NSObject, NSCoding, Mappable{

	var v : Int?
	var id : String?
    var localId : String?
	var createdAt : String?
    var changeStreamCreatedAt : String?
	var descriptionField : String?
	var done : Bool?
	var listId : String?
    var listName : String?
	var note : String?
    var dueDate : String?
    var remindAt : Date?
	var updatedAt : String?
    var assigneeId : UserData?
    var parentCategory : NSCategory?


	class func newInstance(map: Map) -> Mappable?{
		return TaskData()
	}
	required init?(map: Map){}
    override init(){}

	func mapping(map: Map)
	{
		v <- map["__v"]
		id <- map["_id"]
		createdAt <- map["createdAt"]
        changeStreamCreatedAt <- map["changeStreamCreatedAt"]
		descriptionField <- map["description"]
		done <- map["done"]
		listId <- map["listId"]
		note <- map["note"]
		updatedAt <- map["updatedAt"]
        assigneeId <- map["assigneeId"]
        dueDate <- map["dueDate"]
		
	}
    
    func fromGenericModel(generic: EntityData?)-> TaskData {
        
        let data            = TaskData()
        
        data.id                         = generic?.id
      
        data.createdAt                  = generic?.createdAt
        data.descriptionField           = generic?.descriptionField
        
//        let userData                    = UserData()
//        userData.id                     = generic?.assigneeId
//        userData.name                   = generic?.assigneeName
//        userData.email                  = generic?.assigneeEmail
//        
//        data.assigneeId                 = userData
        
        data.updatedAt                  = generic?.updatedAt
        data.done                       = generic?.done
        data.listId                     = generic?.listId
        data.note                       = generic?.note
        data.dueDate                    = generic?.dueDate
        
        return data
    }
    
    func fromNSManagedObject(tasks: [TaskEntity])-> [TaskData] {
        
        var arrTasks = [TaskData]()
        
        for task in tasks {
            
            let data            = TaskData()
            
            data.id                         = task.id
            data.localId                    = task.id
            if let id = task.serverId {
                data.id             = id
            }
            data.createdAt                  = task.createdAt
            data.descriptionField           = task.descriptionField
            
            let userData                    = UserData()
            userData.id                     = task.assigneeId
            userData.name                   = task.assigneeName
            userData.email                  = task.assigneeEmail
            
            data.assigneeId                 = userData
            
            data.updatedAt                  = task.updatedAt
            data.done                       = task.done
            data.listId                     = task.listId
            data.listName                   = task.listName
            data.note                       = task.note
            data.dueDate                    = task.dueDate
            data.remindAt                   = task.remindAt
            data.parentCategory             = task.category
            
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
         createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         done = aDecoder.decodeObject(forKey: "done") as? Bool
         listId = aDecoder.decodeObject(forKey: "listId") as? String
         note = aDecoder.decodeObject(forKey: "note") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
         assigneeId = aDecoder.decodeObject(forKey: "assigneeId") as? UserData

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
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "createdAt")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if done != nil{
			aCoder.encode(done, forKey: "done")
		}
		if listId != nil{
			aCoder.encode(listId, forKey: "listId")
		}
		if note != nil{
			aCoder.encode(note, forKey: "note")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updatedAt")
		}
        if assigneeId != nil{
            aCoder.encode(assigneeId, forKey: "assigneeId")
        }

	}

}
