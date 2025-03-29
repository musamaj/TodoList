//
//  BackgroundThemeVC.swift
//  TodoList
//
//  Created by Usama Jamil on 03/04/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit


class BackgroundThemeVC: BaseVC {

    
    
    // Mark:- IBOutlets
    
    
    @IBOutlet weak var tasksTableView           : UITableView!
    @IBOutlet weak var themesCollectionView     : UICollectionView!
    @IBOutlet weak var navBarView               : UIView!
    @IBOutlet weak var bgImage                  : UIImageView!
    
    
    var tasksAdapter                            : TasksAdapter?
    var themesAdapter                           : ThemesAdapter?
    var tasksVM                                 = TasksListVM()
    
    private let gradientLayer                   = CAGradientLayer()
    
    // Mark:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tasksTableView.isUserInteractionEnabled = false
        self.setTheme()
        
        tasksVM.fethcDummyTasks()
        self.tasksAdapter = TasksAdapter.init(tableView: self.tasksTableView, fetchedData: [""], viewModel: tasksVM)
        self.themesAdapter = ThemesAdapter.init(collectionView: self.themesCollectionView)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setTheme() {
        AppTheme.setNavBartheme(view: self.navBarView)
        let index = appUtility.appTheme ?? 12
        
        if let colorTheme = App.arrThemes[index] as? UIColor {
            self.bgImage.image = nil
            self.bgImage.backgroundColor = colorTheme.lighter()
            
        } else if let gradientTheme = App.arrThemes[index] as? [UIColor] {
            self.bgImage.image = nil
            self.bgImage.backgroundColor = .clear
            AppTheme.updateGradient(view: view, gradients: gradientTheme, layer: gradientLayer)
            
        } else if let imageStr = App.arrThemes[index] as? String {
            self.bgImage.backgroundColor = .clear
            self.bgImage.image = UIImage.init(named: imageStr)
        }
        
        self.tasksAdapter?.reloadAdapter()        
    }
    
    
    // Mark:- Functions
    
    
    @IBAction func actDone(_ sender: Any) {
        self.pop()
    }

}
