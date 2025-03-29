//
//  TitleHeader.swift
//  TodoList
//
//  Created by Usama Jamil on 26/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class TitleHeader: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    
    func viewConfiguration(title : String) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 60)
        self.backgroundColor = .clear
        let headerTitle = UILabel.init(frame: CGRect(x:15, y:10, width: 200, height: 40))
        headerTitle.text = title
        headerTitle.textColor = .darkGray
        headerTitle.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.addSubview(headerTitle)
    }
 

}
