//
//  ThemeCell.swift
//  TodoList
//
//  Created by Usama Jamil on 06/04/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit

class ThemeCell: UICollectionViewCell {

    @IBOutlet weak var imgTheme     : UIImageView!
    @IBOutlet weak var imgTick      : UIImageView!
    @IBOutlet weak var gradientView : UIView!
    
    private let gradientLayer       = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setTheme(indexPath: IndexPath) {
        
        self.imgTheme.setRounded(cornerRadius: 10.0, width: 2.0, color: .white)
        self.gradientView.setRounded(cornerRadius: 10.0)
        
        if let colorTheme = App.arrThemes[indexPath.row] as? UIColor {
            self.imgTheme.image = nil
            self.imgTheme.backgroundColor = colorTheme
            
        } else if let gradientTheme = App.arrThemes[indexPath.row] as? [UIColor] {
            self.imgTheme.image = nil
            self.imgTheme.backgroundColor = .clear
            AppTheme.updateGradient(view: gradientView, gradients: gradientTheme, layer: gradientLayer)
            
        } else if let imageStr = App.arrThemes[indexPath.row] as? String {
            self.imgTheme.backgroundColor = .clear
            self.imgTheme.image = UIImage.init(named: imageStr)
        }
    }

}
