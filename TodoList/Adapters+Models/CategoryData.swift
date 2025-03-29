//
//	CategoryData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper

struct CatModelKeys {
    static let v                =  "__v"
    static let id               =  "_id"
    static let changeStream     =  "changeStreamCreatedAt"
    static let createdAt        =  "createdAt"
    static let name             =  "name"
    static let owner            =  "owner"
    static let tasks            =  "tasks"
    static let updatedAt        =  "updatedAt"
    static let accepted         =  "accepted"
}


class CategoryData : NSObject, NSCoding, Mappable{

	var v : Int?
	var id : String?
    var changeStreamCreatedAt : String?
	var createdAt : String?
	var name : String?
	var updatedAt : String?
    var owner : UserData?
    var tasks : [TaskData]?
    var synced : Bool = false
    var accepted : Bool = true
    var fetchId : String?
    var parentFolder: FoldersEntity?
    var expanded : Bool = false


	class func newInstance(map: Map) -> Mappable?{
		return CategoryData()
	}
	required init?(map: Map){}
	public override init(){}

    
	func mapping(map: Map)
	{
		v <- map[CatModelKeys.v]
		id <- map[CatModelKeys.id]
        changeStreamCreatedAt <- map[CatModelKeys.changeStream]
		createdAt <- map[CatModelKeys.createdAt]
		name <- map[CatModelKeys.name]
		owner <- map[CatModelKeys.owner]
        tasks <- map[CatModelKeys.tasks]
		updatedAt <- map[CatModelKeys.updatedAt]
        accepted <- map[CatModelKeys.accepted]
		
	}
    
    class func addInbox()-> CategoryData {
        
        let inbox       = CategoryData()
        inbox.id        = UUID().uuidString
        inbox.name      = App.placeholders.catInbox
        inbox.accepted  = true
        inbox.synced    = true
        
        NSCategory.saveCategory(inbox)
        
        return inbox
    }
    
    func fromGenericModel(generic: EntityData?)-> CategoryData {
        
        let data            = CategoryData()
        let userData        = UserData()
        
        data.id             = generic?.id
    
        data.createdAt      = generic?.createdAt
        data.name           = generic?.name
        
        userData.id         = generic?.owner?.id
        userData.name       = generic?.owner?.name
        userData.email      = generic?.owner?.email
        
        data.owner          = userData
        data.updatedAt      = generic?.updatedAt
        
        if let accept = generic?.accepted {
            data.accepted       = accept
        }
        
        return data
        
    }
    
    func fromNSManagedObject(categories: [NSCategory])-> [CategoryData] {
        
        var arrCategories = [CategoryData]()
        
        for category in categories {
            
            let data            = CategoryData()
            let userData        = UserData()
            
            data.id             = category.id
            if let id = category.serverId {
                data.id             = id
            }
            data.createdAt      = category.createdAt
            data.name           = category.name
            
            userData.id         = category.ownerId
            userData.name       = category.ownerName
            userData.email      = category.ownerEmail
            
            data.owner          = userData
            
            data.updatedAt      = category.updatedAt
            data.synced         = category.synced
            data.accepted       = category.accepted
            data.parentFolder   = category.folder
            
            arrCategories.append(data)
        }
        
        return arrCategories
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         v = aDecoder.decodeObject(forKey: CatModelKeys.v) as? Int
         id = aDecoder.decodeObject(forKey: CatModelKeys.id) as? String
         createdAt = aDecoder.decodeObject(forKey: CatModelKeys.createdAt) as? String
         name = aDecoder.decodeObject(forKey: CatModelKeys.name) as? String
         owner = aDecoder.decodeObject(forKey: CatModelKeys.owner) as? UserData
         tasks = aDecoder.decodeObject(forKey: CatModelKeys.tasks) as? [TaskData]
         updatedAt = aDecoder.decodeObject(forKey: CatModelKeys.updatedAt) as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if v != nil{
			aCoder.encode(v, forKey: CatModelKeys.v)
		}
		if id != nil{
			aCoder.encode(id, forKey: CatModelKeys.id)
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: CatModelKeys.createdAt)
		}
		if name != nil{
			aCoder.encode(name, forKey: CatModelKeys.name)
		}
		if owner != nil{
			aCoder.encode(owner, forKey: CatModelKeys.owner)
		}
        if tasks != nil{
            aCoder.encode(tasks, forKey: CatModelKeys.tasks)
        }
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: CatModelKeys.updatedAt)
		}

	}

}
