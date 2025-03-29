//
//  GenericRefreshControl.swift
//  ListFixx
//
//  Created by Usama Jamil on 22/04/2019.
//  Copyright © 2019 Square63. All rights reserved.
//

import UIKit
import KRPullLoader


class GenericRefreshControl: NSObject {
    
    var page        = 1
    
    var pageRequest : (()->Void)?
    var pullRequest : (()->Void)?
    
    
    func setupRefreshControls(adapter: NSObject, tableView: UIScrollView) {
        let refreshControl = KRPullLoadView()
        let pullrefreshControl = KRPullLoadView()
        refreshControl.delegate = adapter as? KRPullLoadViewDelegate
        pullrefreshControl.delegate = adapter as? KRPullLoadViewDelegate
        tableView.addPullLoadableView(refreshControl, type: .loadMore)
        tableView.addPullLoadableView(pullrefreshControl, type: .refresh)
        pullrefreshControl.messageLabel.text = refreshStr
        
    }
    
    func setupCollectionRefreshControls(collectionView: UICollectionView) {
        collectionView.addPullLoadableView(HorizontalPullLoadView(), type: .refresh)
        collectionView.addPullLoadableView(HorizontalPullLoadView(), type: .loadMore)
    }
    
    func handlePagination(state: KRPullLoaderType , completionHandler: @escaping ()->Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
            if state == .loadMore {
                self.pageRequest?()
            } else {
                if let pullReq = self.pullRequest {
                    pullReq()
                } else {
                    self.pageRequest?()
                }
            }
            completionHandler()
        }
    }
    
}



extension GenericRefreshControl: KRPullLoadViewDelegate {
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType)
    {
        switch state {
        case let .loading(completionHandler):
            self.handlePagination(state: type, completionHandler: completionHandler)
        default: break
        }
        return
        
    }
    
}

