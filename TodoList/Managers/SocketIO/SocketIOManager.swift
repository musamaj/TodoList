//
//  SocketIOManager.swift
//  TodoList
//
//  Created by Usama Jamil on 27/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import SocketIO
import SVProgressHUD
import ObjectMapper
import SwiftQueue
import Reachability


class SocketIOManager: NSObject {
    
    
    static let sharedInstance = SocketIOManager()
    
    var connected       = Dynamic.init(Bool())
    
    var manager = SocketManager(socketURL: URL(string: baseUrl)!, config: [.log(true), .compress, .connectParams([App.paramKeys.auth: Persistence.shared.accessToken ?? ""])])
    var socket  : SocketIOClient!
    
    override init() {
        super.init()
        
        //manager.reconnects = true
        socket = manager.defaultSocket
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            print("data is here...: \(data)")
        }
        
    }
    
    func establishConnection() {
        
        if Persistence.shared.isUserAlreadyLoggedIn {
            
            if Persistence.shared.isAppAlreadyLaunchedForFirstTime {
                SVProgressHUD.show()
            }
            
            manager = SocketManager(socketURL: URL(string: baseUrl)!, config: [.log(true), .compress, .connectParams([App.paramKeys.auth: Persistence.shared.accessToken ?? ""])])
            socket = manager.defaultSocket
            socket?.connect()
        }
        
        self.socket.on("success") { (data, ack) in
            print("original data is: \(data)")
            
            //SVProgressHUD.dismiss()
            self.connected.value = true

            print("pending jobs are \(String(describing: JobFactory.queueManager?.jobCount()))")
            JobFactory.setManager()
            JobFactory.queueManager?.isSuspended = false

        }
        
        socket.on("error") { (data, ack) in
            print("Error data is: \(data)")
            
            SVProgressHUD.dismiss()
            self.connected.value = false
        }
        
        socket.on(clientEvent: .disconnect) {data, ack in
            //self.establishConnection()
        }
        
        self.initializeListeners()
        
    }
    
    func initializeListeners() {
        CategoryLoader().listeners()
        TaskLoader().listeners()
        SubtaskLoader().listeners()
        CommentsLoader().listeners()
    }
    
    func closeConnection() {
        socket?.disconnect()
    }
}
