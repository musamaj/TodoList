//
//  ProfileLoader.swift
//  TodoList
//
//  Created by Usama Jamil on 31/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import ObjectMapper
import SVProgressHUD


class ProfileLoader: NSObject {
    
    
    fileprivate let manager = NetworkManager()
    
    
    // MARK:- TASKS Creation
    
    
    func uploadProfileImg(image: UIImage?, successBlock success: @escaping ((TaskData?) -> Void), failureBlock failure: @escaping ((_ error: NSError?) -> Void)) {
        
        let service = Endpoint.uploadImg
        
        SVProgressHUD.show()
        
        manager.mutipartRequest(.post, service: service, multipartFormData: { (data) in
            
            if let imagetoUpload = image {
                let imgData     = imagetoUpload.jpegData(compressionQuality: 1.0)
                data.append(imgData!, withName: "image",fileName: "\(NSDate().timeIntervalSince1970*1000).jpg", mimeType: "image/jpg")
            }
            
        }, uploadProgress: { (progress) in
            
        } , success: { (urlResponse, jsonTopModel) in
            
            SVProgressHUD.dismiss()
            if urlResponse!.statusCode == 200 || urlResponse!.statusCode == 201 {
                guard let response = jsonTopModel.data as? [String : Any] else {
                    failure(NSError.init(errorMessage: jsonTopModel.message, code: urlResponse?.statusCode))
                    return
                }
                
                guard let data = Mapper<TaskData>(context: service).map(JSON: response) else {
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

            
        }) { (error) in
            
        }
    }
    
}
