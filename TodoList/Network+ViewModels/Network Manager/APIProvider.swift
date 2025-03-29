//
//  APIProvider.swift
//  Housekeeping
//
//  Created by Muhammad Azher on 17/04/2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import ObjectMapper

//class APIProvider {
//    
//    func getAllPosts(language : String = "en",pageNo : Int = 1,searchText : String, tagIds : String, completion: @escaping (_ postData: PostTopData?) -> Void, failure: @escaping (_ error: Error) -> Void) {
//        
//        
//        var query = "page=\(pageNo)&"
//        
//        var params = ["text":searchText,"tag":tagIds]
//        if language != "en" {
//            params["lang"] = language
//        }
////        print(params.queryParameters)
//        query.append(params.queryParameters)
//        let api = API(method: .get, endPoint: MyEndPoint.getPostList(query), isAuthorized: false,parameters: [:])
//        networkManager.requestObject(api, mapperType: PostTopData.self) { (result) in
//            
//            switch result {
//                
//            case .success(let value):
//                completion(value)
//                break
//
//            case .failure(let error):
//                failure(error)
//                break
//
//            }
//        }
//    }
//    
//    
//    
//    func getBookmaredPosts(language : String = "en", postIds : String, completion: @escaping (_ postData: [PostListData]) -> Void, failure: @escaping (_ error: Error) -> Void) {
//        
//        
//        var params = ["id":postIds]
//        if language != "en" {
//            params["lang"] = language
//        }
//        let query = MyEndPoint.getBookmarkedList(params.queryParameters)
//        let api = API(method: .get, endPoint: query, isAuthorized: false,parameters: [:])
//        networkManager.requestObject(api, mapperType: JSONTopModel.self) { (result) in
//            
//            switch result {
//                
//            case .success(let value):
//                
//                let error = NSError.init(errorMessage: "Unable to get data")
//                
//                guard let dic = value.data as? [[String : AnyObject]] else { failure(error)
//                    return
//                }
//                
//                guard let data = Mapper<PostListData>(context: nil).mapArray(JSONArray: dic) as? [PostListData] else { failure(error)
//                    return
//                }
//                
//                completion(data)
//                break
//
//            case .failure(let error):
//                failure(error)
//                break
//
//            }
//        }
//    }
//    
//    
//    
//    func getPostDetails(language : String = "en",postId : Int,completion: @escaping (_ postData: PostListData) -> Void, failure: @escaping (_ error: Error) -> Void) {
//        var languageStr = ""
//        if language != "en" {
//            languageStr = "?lang=\(language)"
//        }
//        
//        
//        let query = "\(postId)\(languageStr)"
//        
//        let api = API(method: .get, endPoint: MyEndPoint.getPostDetail(query), isAuthorized: false)
//        networkManager.requestObject(api, mapperType: JSONTopModel.self) { (result) in
//            
//            switch result {
//                
//            case .success(let value):
//                let error = NSError.init(errorMessage: "Unable to get data")
//                
//                guard let dic = value.data as? [String : AnyObject] else { failure(error)
//                    return
//                }
//                
//                guard let data = Mapper<PostListData>(context: nil).map(JSON: dic) else { failure(error)
//                    return
//                }
//                
//                completion(data)
//                break
//
//            case .failure(let error):
//                failure(error)
//                break
//
//            }
//        }
//    }
//    
//    
//    
//    func getAllTags(completion: @escaping (_ postData: TagTopData?) -> Void, failure: @escaping (_ error: Error) -> Void) {
//        
//        let api = API(method: .get, endPoint: MyEndPoint.getTags, isAuthorized: false)
//        networkManager.requestObject(api, mapperType: TagTopData.self) { (result) in
//            
//            switch result {
//                
//            case .success(let value):
//                completion(value)
//                break
//
//            case .failure(let error):
//                failure(error)
//                break
//
//            }
//        }
//    }
//    
//    
//    
//    
//}
//
//
//
//
//
//extension Dictionary {
//    var queryParameters: String {
//        var parts: [String] = []
//        for (key, value) in self {
//            let part = String(format: "%@=%@",
//                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
//                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//            parts.append(part as String)
//        }
//        return parts.joined(separator: "&")
//    }
//    
//}


