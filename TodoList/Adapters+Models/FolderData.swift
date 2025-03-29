//
//  FolderData.swift
//  TodoList
//
//  Created by Usama Jamil on 22/04/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import Foundation
import ObjectMapper


class FolderData : NSObject, NSCoding, Mappable{
    
    var v : Int?
    var id : String?
    var changeStreamCreatedAt : String?
    var createdAt : String?
    var name : String?
    var owner : String?
    var updatedAt : String?
    var fetchId : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return FolderData()
    }
    required init?(map: Map){}
    public override init(){}
    
    func mapping(map: Map)
    {
        v <- map["__v"]
        id <- map["_id"]
        changeStreamCreatedAt <- map["changeStreamCreatedAt"]
        createdAt <- map["createdAt"]
        name <- map["name"]
        owner <- map["owner"]
        updatedAt <- map["updatedAt"]
        
    }
    
    class func initWithParams(title: String)-> FolderData {
        
        let folder                            = FolderData()
        folder.id                             = UUID().uuidString
        folder.createdAt                      = Utility.getCurrentTimeStamp()
        folder.name                           = title
        
        return folder
    }
    
    func fromGenericModel(generic: EntityData?)-> FolderData {
        
        let data            = FolderData()
        
        data.id             = generic?.id
        data.createdAt      = generic?.createdAt
        data.name           = generic?.name
        data.updatedAt      = generic?.updatedAt
        
        
        return data
        
    }
    
    func fromNSManagedObject(categories: [FoldersEntity])-> [FolderData] {
        
        var arrFolders = [FolderData]()
        
        for category in categories {
            
            let data            = FolderData()
            
            data.id             = category.id
            if let id = category.serverId {
                data.id             = id
            }
            data.createdAt      = category.createdAt
            data.name           = category.name
            data.updatedAt      = category.updatedAt
            
            arrFolders.append(data)
        }
        
        return arrFolders
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
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updatedAt")
        }
        
    }
    
}
