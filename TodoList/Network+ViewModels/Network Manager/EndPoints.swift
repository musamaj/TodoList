//
//  EndPoints.swift
//  Housekeeping
//
//  Created by Muhammad Azher on 17/04/2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation


enum MyEndPoint: URLDirectable {
    
    case getPostDetail(String)    
    case login
    case register
    case guest
    case authPosts
    case chefDetail(String)
    case requestOrder
    
    func urlString() -> String {
        
        var endpoint = ""
        
        switch (self) {
            
        case .getPostDetail(let postId):
            endpoint = "get_post_detail/\(postId)"
            
        case .login:
            endpoint = "user/login?"
            
        case .register:
            endpoint = "user/register"
            
        case .guest:
            endpoint = "visitor/posts"
            
        case .authPosts:
            endpoint = "user/all/posts"
            
        case .chefDetail(let chefId):
            endpoint = "user/provider/\(chefId)"
            
        case .requestOrder:
            endpoint = "user/order"
            
        }
        
        return baseUrl + endpoint
    }
}
