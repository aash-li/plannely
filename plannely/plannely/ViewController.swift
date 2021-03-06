//
//  ViewController.swift
//  plannely
//
//  Created by Ashley Liao on 9/1/20.
//  Copyright © 2020 Ashley Liao. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var desc: String = ""
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    
    private var data = [ToDoItem]()
    private var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(ToDoItem.self).map({ $0 })
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Open the screen where we can seee item info and delete
        let item = data[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "info") as? InfoViewController else {
            return
        }
        
        vc.item = item
        vc.deletionHandler = { [weak self] in
            self?.refresh()
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tappedAddButton() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as? EntryViewController else {
            return
        }
        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        vc.title = "New Item"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refresh() {
        data = realm.objects(ToDoItem.self).map({ $0 })
        table.reloadData()
    }
    
}

