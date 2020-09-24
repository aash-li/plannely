//
//  EntryViewController.swift
//  plannely
//
//  Created by Ashley Liao on 9/23/20.
//  Copyright © 2020 Ashley Liao. All rights reserved.
//
import RealmSwift
import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var textField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var descField: UITextField!
    
    private let realm = try! Realm()
    public var completionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.becomeFirstResponder()
        textField.delegate = self
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        datePicker.setDate(Date(), animated:true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(tappedSaveButton))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func tappedSaveButton() {
        if let text = textField.text, !text.isEmpty, let desc = descField.text {
            let date = datePicker.date
            
            realm.beginWrite()
            
            let newItem = ToDoItem()
            newItem.date = date
            newItem.title = text
            newItem.desc = desc
            realm.add(newItem)
            
            try! realm.commitWrite()
            
            completionHandler?()
            navigationController?.popToRootViewController(animated: true)
        } else {
            print("Add Something")
        }
    }

}
