//
//  CommunityAuth.swift
//  DigitalTown
//
//  Created by Waqar Ali on 17/04/2018.
//  Copyright © 2018 Waqar Ali. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper


class Auth: NSObject
{
    
    fileprivate let manager = NetworkManager()
    
    
    func Register(_ parameters: [String: AnyObject], successBlock success: @escaping ((RegisterData?) -> Void), failureBlock failure: @escaping ((_ error: NSError?) -> Void)) {
        
        let service = Endpoint.register
        
        _ = manager.request(.post, service: service , parameters: parameters, success: { (urlResponse, jsonTopModel) in

            guard let response = jsonTopModel.data as? [String : Any] else {
                failure(NSError.init(errorMessage: jsonTopModel.message, code: urlResponse?.statusCode))
                return
            }
            
            guard let data = Mapper<RegisterData>(context: service).map(JSON: response) else {
                failure(NSError.init(errorMessage: jsonTopModel.message, code: urlResponse?.statusCode))
                return
            }
            
            if jsonTopModel.message == successKey.lowercased() {
                success(data)
            } else {
                failure(NSError.init(errorMessage: jsonTopModel.message, code: urlResponse?.statusCode))
                return
            }
            
        }, failure: { (error) in
            failure(error)
        })
    }
    
    
    func Login(_ parameters: [String: String], successBlock success: @escaping ((RegisterData?) -> Void), failureBlock failure: @escaping ((_ error: NSError?) -> Void)) {
        
        let service = Endpoint.login
        
        _ = manager.request(.post, service: service , parameters: parameters as [String : AnyObject], success: { (urlResponse, jsonTopModel) in
            
            if urlResponse!.statusCode == 200 || urlResponse!.statusCode == 201 {
                guard let response = jsonTopModel.data as? [String : Any] else {
                    failure(NSError.init(errorMessage: jsonTopModel.message, code: urlResponse?.statusCode))
                    return
                }
                
                guard let data = Mapper<RegisterData>(context: service).map(JSON: response) else {
                    failure(NSError.init(errorMessage: jsonTopModel.message, code: urlResponse?.statusCode))
                    return
                }
                
                if jsonTopModel.message == successKey.lowercased() {
                    success(data)
                } else {
                    failure(NSError.init(errorMessage: jsonTopModel.message, code: urlResponse?.statusCode))
                    return
                }
            }
        }, failure: { (error) in
            failure(error)
        })
    }

    
    func ForgotPwd(_ parameters: [String: String], successBlock success: @escaping ((String?) -> Void), failureBlock failure: @escaping ((_ error: NSError?) -> Void)) {
        
        let service = Endpoint.forgot
        
        _ = manager.request(.post, service: service , parameters: parameters as [String : AnyObject], success: { (urlResponse, jsonTopModel) in
            
            if urlResponse!.statusCode == 200 || urlResponse!.statusCode == 201 {
                
                if jsonTopModel.message == successKey.lowercased() {
                    success(jsonTopModel.message)
                } else {
                    failure(NSError.init(errorMessage: jsonTopModel.message, code: urlResponse?.statusCode))
                    return
                }
            }
        }, failure: { (error) in
            failure(error)
        })
    }
    
    func fetchChangeStreams(successBlock success: @escaping (([GenericData]?) -> Void), failureBlock failure: @escaping ((_ error: NSError?) -> Void)) {
        
        let service = Endpoint.changeStreams(Persistence.shared.refreshToken ?? Utility.getCurrentTimeStamp())
        
        _ = manager.request(.get, service: service, authorized: true, success: { (urlResponse, jsonTopModel) in
            
            if urlResponse!.statusCode == 200 || urlResponse!.statusCode == 201 {
                guard let response = jsonTopModel.data else {
                    failure(NSError.init(errorMessage: jsonTopModel.message, code: urlResponse?.statusCode))
                    return
                }
                
                guard let data = Mapper<GenericData>(context: service).mapArray(JSONObject: response) else {
                    failure(NSError.init(errorMessage: jsonTopModel.message, code: urlResponse?.statusCode))
                    return
                }
                
                if jsonTopModel.message == successKey.lowercased() {
                    success(data)
                } else {
                    failure(NSError.init(errorMessage: jsonTopModel.message, code: urlResponse?.statusCode))
                    return
                }
            }
        }, failure: { (error) in
            failure(error)
        })
    }
    
}
