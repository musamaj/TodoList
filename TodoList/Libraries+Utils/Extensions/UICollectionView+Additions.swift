//
//  UICollectionView+Additions.swift
//  FanTazTech
//
//  Created by Muhammad Azher on 17/01/2018.
//  Copyright © 2018 Expertinsol. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func registerNibFrom(cellClass: UICollectionViewCell.Type) {
        let cellInfo = cellClass.identifier
        register(UINib(nibName: cellInfo, bundle: nil), forCellWithReuseIdentifier: cellInfo)
    }
    
    func registerNibFrom(headerClass: UICollectionReusableView.Type) {

        let cellInfo = headerClass.identifier
        register(UINib(nibName: cellInfo, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellInfo)
    }

    func registerNibFrom(footerClass: UICollectionReusableView.Type) {
        
        let cellInfo = footerClass.identifier
        register(UINib(nibName: cellInfo, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: cellInfo)
    }
    func dequeue<T: Any>(cell: UICollectionViewCell.Type, indexPath : IndexPath) -> T? {
        
       return dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as? T
    }
}








extension UICollectionView {
    
    func addRefreshControl(_ refresher: UIRefreshControl, withSelector selector:Selector) {
        
        refresher.addTarget(nil, action: selector, for: .valueChanged)
        if #available(iOS 10.0, *) {
            refreshControl = refresher
        } else {
            addSubview(refresher)
        }
    }
    
}
