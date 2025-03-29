//
//	RegisterUser.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class RegisterUser : NSObject, NSCoding, Mappable{

	var v : Int?
	var id : String?
	var createdAt : String?
	var email : String?
	var name : String?
	var updatedAt : String?


	class func newInstance(map: Map) -> Mappable?{
		return RegisterUser()
	}
	required init?(map: Map){}
    override init(){}

	func mapping(map: Map)
	{
		v <- map["__v"]
		id <- map["_id"]
		createdAt <- map["createdAt"]
		email <- map["email"]
		name <- map["name"]
		updatedAt <- map["updatedAt"]
		
	}
    
    class func initwithParams(email: String)-> RegisterUser {
        let userData                        = RegisterUser()
        userData.id                         = UUID().uuidString
        userData.createdAt                  = Utility.getCurrentTimeStamp()
        userData.email                      = email
        
        return userData
    }
    
    func fromNSManagedObject(users: [SharedUsersEntity])-> [RegisterUser] {
        
        var arrUsers = [RegisterUser]()
        
        for user in users {
            
            let data            = RegisterUser()
            
            data.id             = user.id
            if let id = user.serverId {
                data.id             = id
            }
            
            data.name                   = user.name
            data.email                  = user.email
            
            
            arrUsers.append(data)
        }
        
        return arrUsers
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
         email = aDecoder.decodeObject(forKey: "email") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
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
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updatedAt")
		}

	}

}
