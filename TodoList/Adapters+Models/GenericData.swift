//
//	GenericData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class GenericData : NSObject, NSCoding, Mappable{

	var v : Int?
	var id : String?
	var action : String?
	var createdAt : String?
	var entityData : EntityData?
	var entityType : String?
	var updatedAt : String?


	class func newInstance(map: Map) -> Mappable?{
		return GenericData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		v <- map["__v"]
		id <- map["_id"]
		action <- map["action"]
		createdAt <- map["createdAt"]
		entityData <- map["entityData"]
		entityType <- map["entityType"]
		updatedAt <- map["updatedAt"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         v = aDecoder.decodeObject(forKey: "__v") as? Int
         id = aDecoder.decodeObject(forKey: "_id") as? String
         action = aDecoder.decodeObject(forKey: "action") as? String
         createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
         entityData = aDecoder.decodeObject(forKey: "entityData") as? EntityData
         entityType = aDecoder.decodeObject(forKey: "entityType") as? String
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
		if action != nil{
			aCoder.encode(action, forKey: "action")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "createdAt")
		}
		if entityData != nil{
			aCoder.encode(entityData, forKey: "entityData")
		}
		if entityType != nil{
			aCoder.encode(entityType, forKey: "entityType")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updatedAt")
		}

	}

}