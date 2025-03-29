//
//  CategoryListResponse.swift
//  TodoList
//
//  Created by Usama Jamil on 30/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import ObjectMapper


class CategoryListResponse : NSObject, NSCoding, Mappable{
    
    @objc var data : [CategoryData]?
    var message : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return CategoryListResponse()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        data <- map["data"]
        message <- map["message"]
    }
    
    func getNameOf(property: objc_property_t) -> String? {
        guard let name: NSString = NSString(utf8String: property_getName(property)) else { return nil }
        return name as String
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        data = aDecoder.decodeObject(forKey: "data") as? [CategoryData]
        message = aDecoder.decodeObject(forKey: "message") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if data != nil{
            aCoder.encode(data, forKey: "data")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        
    }
    
}
