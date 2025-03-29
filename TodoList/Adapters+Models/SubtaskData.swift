//
//	SubtaskData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class SubtaskData : NSObject, NSCoding, Mappable{

	var v : Int?
	var id : String?
    var changeStreamCreatedAt : String?
	var createdAt : String?
	var descriptionField : String?
	var done : Bool?
	var taskId : String?
	var updatedAt : String?
    var parentTask : TaskEntity?


	class func newInstance(map: Map) -> Mappable?{
		return SubtaskData()
	}
	required init?(map: Map){}
    override init(){}

	func mapping(map: Map)
	{
		v <- map["__v"]
		id <- map["_id"]
        changeStreamCreatedAt <- map["changeStreamCreatedAt"]
		createdAt <- map["createdAt"]
		descriptionField <- map["description"]
		done <- map["done"]
		taskId <- map["taskId"]
		updatedAt <- map["updatedAt"]
		
	}
    
    func fromGenericModel(generic: EntityData?)-> SubtaskData {
        
        let data            = SubtaskData()
        
        data.id                         = generic?.id
        data.createdAt                  = generic?.createdAt
        data.descriptionField           = generic?.descriptionField
        data.updatedAt                  = generic?.updatedAt
        data.done                       = generic?.done
        data.taskId                     = generic?.taskId
        
        return data
    }
    
    func fromNSManagedObject(tasks: [SubtaskEntity])-> [SubtaskData] {
        
        var arrTasks = [SubtaskData]()
        
        for task in tasks {
            
            let data            = SubtaskData()
            
            data.id                         = task.id
            if let id = task.serverId {
                data.id             = id
            }
            data.createdAt                  = task.createdAt
            data.descriptionField           = task.descriptionField
            data.updatedAt                  = task.updatedAt
            data.done                       = task.done
            data.taskId                     = task.taskId
            
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
         taskId = aDecoder.decodeObject(forKey: "taskId") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String

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
		if taskId != nil{
			aCoder.encode(taskId, forKey: "taskId")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updatedAt")
		}

	}

}
