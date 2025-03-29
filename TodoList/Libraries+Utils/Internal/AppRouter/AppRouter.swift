//
//  Routable.swift
//  Hectagon
//
//  Created by Usama Jamil on 14/02/2019.
//  Copyright © 2019 Square63. All rights reserved.
//


import UIKit

public protocol AppRouter {
    
    func present<T: UIViewController>(storyboard: AppStoryboard, identifier: String?, animated: Bool, modalPresentationStyle: UIModalPresentationStyle?, configure: ((T) -> Void)?, completion: ((T) -> Void)?)
    func show<T: UIViewController>(storyboard: AppStoryboard, identifier: String?, configure: ((T) -> Void)?)
    func showDetailViewController<T: UIViewController>(storyboard: AppStoryboard, identifier: String?, configure: ((T) -> Void)?)
    
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

public extension AppRouter where Self: UIViewController {
    
    /**
     Presents the intial view controller of the specified storyboard modally.
     
     - parameter storyboard: Storyboard name.
     - parameter identifier: View controller name.
     - parameter configure: Configure the view controller before it is loaded.
     - parameter completion: Completion the view controller after it is loaded.
     */
    func present<T: UIViewController>(storyboard: AppStoryboard, identifier: String? = nil, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle? = nil, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboard.rawValue)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T
            else { return assertionFailure("Invalid controller for storyboard \(storyboard).") }
        
        if let modalPresentationStyle = modalPresentationStyle {
            controller.modalPresentationStyle = modalPresentationStyle
        }
        
        configure?(controller)
        
        present(controller, animated: animated) {
            completion?(controller)
        }
    }
    
    /**
     Present the intial view controller of the specified storyboard in the primary context.
     Set the initial view controller in the target storyboard or specify the identifier.
     
     - parameter storyboard: Storyboard name.
     - parameter identifier: View controller name.
     - parameter configure: Configure the view controller before it is loaded.
     */
    func show<T: UIViewController>(storyboard: AppStoryboard, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboard.rawValue)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T
            else { return assertionFailure("Invalid controller for storyboard \(storyboard).") }
        
        configure?(controller)
        
        //self.navigationController?.pushViewController(controller, animated: true)
        show(controller, sender: self)
    }
    
    /**
     Present the intial view controller of the specified storyboard in the secondary (or detail) context.
     Set the initial view controller in the target storyboard or specify the identifier.
     
     - parameter storyboard: Storyboard name.
     - parameter identifier: View controller name.
     - parameter configure: Configure the view controller before it is loaded.
     */
    func showDetailViewController<T: UIViewController>(storyboard: AppStoryboard, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboard.rawValue)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T
            else { return assertionFailure("Invalid controller for storyboard \(storyboard).") }
        
        configure?(controller)
        
        showDetailViewController(controller, sender: self)
    }
    
    func dismiss(delegate: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let navController = delegate.navigationController else {
            delegate.dismiss(animated: true, completion: completion)
            return
        }
        
        guard navController.viewControllers.count > 1 else {
            return navController.dismiss(animated: true, completion: completion)
        }
        
        navController.popViewController(animated: true)
    }
}




public extension UIStoryboard {
    
    /**
     Creates and returns a storyboard object for the specified storyboard resource file in the main bundle of the current application.
     
     - parameter name: The name of the storyboard resource file without the filename extension.
     
     - returns: A storyboard object for the specified file. If no storyboard resource file matching name exists, an exception is thrown.
     */
    convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
}


extension UIViewController {
    
    
    // MARK:- General
    
    
    func navigateToHome() {
        let homeVC = CategoryListingVC.instantiate(fromAppStoryboard: .Categories)        
        var opt = UIWindow.TransitionOptions(direction: .toRight, style: .easeInOut)
        opt.duration = 0.25
        UIApplication.shared.keyWindow?.setRootViewController(homeVC, options: opt)
    }
    
    func popToHome() {
        let homeVC = CategoryListingVC.instantiate(fromAppStoryboard: .Categories)
        var opt = UIWindow.TransitionOptions(direction: .toLeft, style: .easeInOut)
        opt.duration = 0.25
        UIApplication.shared.keyWindow?.setRootViewController(homeVC, options: opt)
    }
    
    func pop() {
        dismiss(delegate: self, animated: true, completion: nil)
    }
    
    func logoutNavigation() {
        let mainVC = MainVC.instantiate(fromAppStoryboard: .Main)
        var opt = UIWindow.TransitionOptions(direction: .toLeft, style: .easeInOut)
        opt.duration = 0.25
        UIApplication.shared.keyWindow?.setRootViewController(mainVC, options: opt)
    }
    
    
    // MARK:- Categories
    
    
    func navigateToSearch() {
        show(storyboard: AppStoryboard.UserProfile, identifier: SearchVC.identifier)
    }
    
    func navigateToThemes() {
        //show(storyboard: AppStoryboard.UserProfile, identifier: BackgroundThemeVC.identifier)
        
        present(storyboard: AppStoryboard.UserProfile, identifier: BackgroundThemeVC.identifier, animated: true, modalPresentationStyle: UIModalPresentationStyle.fullScreen, configure: { (controller: BackgroundThemeVC) in
        }) { (controller: BackgroundThemeVC) in
        }
        
    }
    
    func navigateToNotifications() {
//        present(storyboard: AppStoryboard.UserProfile, identifier: NotificationsVC.identifier, animated: true, modalPresentationStyle: UIModalPresentationStyle.fullScreen, configure: { (controller: MembersListVC) in
//        }) { (controller: MembersListVC) in
//        }
//
//        guard let myVC = UIApplication.topViewController() as? CategoryListingVC else {return}
//        let navController = UINavigationController(rootViewController: myVC)
        
        
        let viewController = NotificationsVC.instantiate(fromAppStoryboard: .UserProfile)
        let navController = UINavigationController(rootViewController: viewController)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func navigateToMembers(viewModel: TaskDetailVM) {
        
        present(storyboard: AppStoryboard.Categories, identifier: MembersListVC.identifier, animated: true, modalPresentationStyle: UIModalPresentationStyle.fullScreen, configure: { (controller: MembersListVC) in
            controller.taskDetailVM = viewModel
        }) { (controller: MembersListVC) in
        }
        
        
//        let myVC = MembersListVC.instantiate(fromAppStoryboard: .Categories)
//        myVC.taskDetailVM = viewModel
//        let navController = UINavigationController(rootViewController: myVC)
//        self.navigationController?.present(navController, animated: true, completion: nil)
        
//        show(storyboard: AppStoryboard.Categories, identifier: MembersListVC.identifier) { (controller: MembersListVC) in
//            controller.taskDetailVM = viewModel
//        }
        //show(storyboard: AppStoryboard.Categories, identifier: MembersListVC.identifier, configure: nil)
    }
    
    func navigateToCategoryCreation(_ category: CategoryData = CategoryData()) { //, _ item: NSCategory = NSCategory()) {
        show(storyboard: AppStoryboard.Categories, identifier: CategoryCreationVC.identifier) { (controller: CategoryCreationVC) in
            controller.categoryVM.categoryData.value    = category
            //controller.categoryVM.categoryItem          = item
        }
    }
    
    func navigateToFolders() {
        show(storyboard: AppStoryboard.Categories, identifier: FoldersListingVC.identifier, configure: nil)
    }
    
    
    // MARK:- Tasks
    
    
    func navigateToTasksListing(category: CategoryData, item: NSCategory?, parent: UIViewController? = nil) {
        show(storyboard: AppStoryboard.Tasks, identifier: TaskListingVC.identifier) { (controller: TaskListingVC) in
            controller.tasksVM.parentVC = parent
            TasksListVM.selectedCategory = category
            NSCategory.selectedCategory = item
        }
    }
    
    func navigateToTaskDetail(task: TaskData, category: CategoryData) {
        show(storyboard: AppStoryboard.Tasks, identifier: TaskDetailVC.identifier) { (controller: TaskDetailVC) in
            controller.taskDetailVM.taskData.value = task
            TaskDetailVM.selectedTask = task
            controller.taskDetailVM.selectedCategory = category
        }
    }
    
    func navigateToNotes(viewModel: TaskDetailVM) {
        show(storyboard: AppStoryboard.Tasks, identifier: NotesVC.identifier) { (controller: NotesVC) in
            controller.taskDetailVM = viewModel
        }
    }
    
   
    // MARK:- UserProfile
    
    
    func navigateToProfile() {
        show(storyboard: AppStoryboard.UserProfile, identifier: AccountDetailsVC.identifier, configure: nil)
    }
    
}
