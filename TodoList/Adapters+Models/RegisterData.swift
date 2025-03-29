//
//	RegisterData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class RegisterData : NSObject, NSCoding, Mappable {

	var token : String?
	var user : RegisterUser?


	class func newInstance(map: Map) -> Mappable?{
		return RegisterData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		token <- map["token"]
		user <- map["user"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         token = aDecoder.decodeObject(forKey: "token") as? String
         user = aDecoder.decodeObject(forKey: "user") as? RegisterUser

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if token != nil{
			aCoder.encode(token, forKey: "token")
		}
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}

	}

}
