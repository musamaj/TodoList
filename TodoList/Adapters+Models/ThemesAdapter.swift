//
//  ThemesAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 06/04/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit


class ThemesAdapter: NSObject {
    
    weak var categoriesCollection: UICollectionView!
    
    
    init(collectionView : UICollectionView)
    {
        super.init()
        
        categoriesCollection = collectionView
        categoriesCollection.registerNibFrom(cellClass: ThemeCell.self)
        
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        
        reloadData()
    }
    
    
    func reloadData() {
        categoriesCollection.reloadData()
    }
    
}

extension ThemesAdapter : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return App.arrThemes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell : ThemeCell = collectionView.dequeue(cell: ThemeCell.self, indexPath: indexPath) else { return UICollectionViewCell() }
        cell.setTheme(indexPath: indexPath)
        
        if appUtility.appTheme == indexPath.row {
            cell.imgTick.tintColor = .white
            cell.imgTick.image = R.image.ic_selection()
        } else {
            cell.imgTick.image = nil
        }
        
        return cell
    }
    
}


extension ThemesAdapter : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ThemeCell {
            cell.imgTick.tintColor = .white
            cell.imgTick.image = R.image.ic_selection()
        }
        
        appUtility.appTheme = indexPath.row
        if let controller = UIApplication.topViewController() as? BackgroundThemeVC {
            controller.setTheme()
        }
        
        self.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ThemeCell {
            cell.imgTick.image = nil
        }
    }
}



extension ThemesAdapter : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
