//
//  NotesVC.swift
//  TodoList
//
//  Created by Usama Jamil on 20/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class NotesVC: BaseVC {

    
    // MARK:- Outlets & Properties
    
    
    @IBOutlet weak var txtNotes     : UITextView!
    var taskDetailVM                = TaskDetailVM()
    
    
    // MARK:- Life Cycle Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.viewConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bindViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    // MARK:- Functions
    
    
    func viewConfig() {
        
        shouldReturn = false
        txtNotes.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15);
        txtNotes.delegate = self
        txtNotes.text = taskDetailVM.taskData.value.note
        txtNotes.becomeFirstResponder()
        self.view.backgroundColor = AppTheme.lightYellow()
        
        self.lightYellowNav(self)
    }
    
    override func actRight() {
        if taskDetailVM.taskData.value.note != txtNotes.text {
            taskDetailVM.taskData.value.note = txtNotes.text
            taskDetailVM.updateTask(params: param())
        } else {
            self.pop()
        }
    }
    
    func bindViews() {
        taskDetailVM.taskData.bind { [weak self] (data) in
            self?.pop()
        }
    }
    
    func param()-> [String: AnyObject] {
        return [App.paramKeys.note      : txtNotes.text as AnyObject]
    }

}


extension NotesVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText:String = textView.text else { return true }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        let rightBarItem = self.navigationItem.rightBarButtonItem ?? UIBarButtonItem()
        
        if updatedText.isEmpty || taskDetailVM.taskData.value.note == updatedText {
            rightBarItem.title = App.barItemTitles.done
        } else {
            rightBarItem.title = App.barItemTitles.save
        }
        return true
    }
    
}
