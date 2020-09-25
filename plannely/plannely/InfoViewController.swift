//
//  InfoViewController.swift
//  plannely
//
//  Created by Ashley Liao on 9/23/20.
//  Copyright © 2020 Ashley Liao. All rights reserved.
//
import RealmSwift
import UIKit

class InfoViewController: UIViewController {
    
    public var item: ToDoItem?
    
    public var deletionHandler: (() -> Void)?
    
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    
    private let realm = try! Realm()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemLabel.text = item?.title
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        descLabel.text = item?.desc
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
    }
    
    @objc private func didTapDelete() {
        guard let myItem = self.item else {
            return
        }
        
        realm.beginWrite()
        realm.delete(myItem)
        try! realm.commitWrite()
        deletionHandler?()
        
        navigationController?.popToRootViewController(animated: true)
    }

}
