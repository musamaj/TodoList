//
//	EntityData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class EntityData : NSObject, NSCoding, Mappable{

    // list data
    
	var v : Int?
	var id : String?
	var createdAt : String?
	var name : String?
	var owner : UserData?
	var updatedAt : String?
    var accepted : Bool = true
    
    // task data
    
    var done : Bool?
    var listId : String?
    var note : String?
    var descriptionField : String?
    var assigneeId : UserData?
    var dueDate : String?

    // subtask data
    
    var taskId : String?

    // comment data
    

    var content : String?
    var userId : UserData?
    var userName : String?


	class func newInstance(map: Map) -> Mappable?{
		return EntityData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		v <- map["__v"]
		id <- map["_id"]
		createdAt <- map["createdAt"]
		name <- map["name"]
		owner <- map["owner"]
		updatedAt <- map["updatedAt"]
        accepted <- map["accepted"]
        
        descriptionField <- map["description"]
        done <- map["done"]
        listId <- map["listId"]
        note <- map["note"]
        assigneeId <- map["assigneeId"]
        dueDate <- map["dueDate"]
        
        taskId <- map["taskId"]
        
        content <- map["content"]
        userId <- map["userId"]
        userName <- map["name"]
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
         name = aDecoder.decodeObject(forKey: "name") as? String
         owner = aDecoder.decodeObject(forKey: "owner") as? UserData
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
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if owner != nil{
			aCoder.encode(owner, forKey: "owner")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updatedAt")
		}

	}

}
