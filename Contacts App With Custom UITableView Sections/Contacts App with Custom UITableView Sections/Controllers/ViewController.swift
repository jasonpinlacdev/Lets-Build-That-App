//
//  ViewController.swift
//  Contacts App with Custom UITableView Sections
//
//  Created by Jason Pinlac on 7/13/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let cellId = "cellId"
    var showIndexPaths = false
    
    
    
    var allContacts: [ExpandableContacts] = [
        ExpandableContacts(contacts: [
            Contact(name: "Jason", isFavorited: false),
            Contact(name: "Mike", isFavorited: false),
            Contact(name: "Davy", isFavorited: false),
            Contact(name: "Gus", isFavorited: false),
            Contact(name: "TK", isFavorited: false),
            Contact(name: "Dan", isFavorited: false),
            Contact(name: "Harrison", isFavorited: false),
            Contact(name: "Tyler", isFavorited: false)
        ],isExpanded: true),
        
        ExpandableContacts(contacts: [
            Contact(name: "Chico", isFavorited: false),
            Contact(name: "Giubi", isFavorited: false),
            Contact(name: "Daisy", isFavorited: false),
        ], isExpanded: true),
        
        ExpandableContacts(contacts:  [
            Contact(name: "Penny", isFavorited: false)
        ], isExpanded: true),
        
        ExpandableContacts(contacts: [
            Contact(name: "Anna", isFavorited: false),
            Contact(name: "Jose", isFavorited: false),
        ], isExpanded: true),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure() {
        self.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Index Path", style: .plain, target: self, action: #selector(handleShowIndexPath))
    }
    
    
    @objc func handleShowIndexPath() {
        var indexPathsToReload: [IndexPath] = []
        
        for section in allContacts.indices {
            if allContacts[section].isExpanded == false {
                continue
            }
            for row in allContacts[section].contacts.indices {
                let indexPath = IndexPath(row: row, section: section)
                indexPathsToReload.append(indexPath)
            }
        }
        
        showIndexPaths.toggle()
        
        let animation: UITableView.RowAnimation
        switch showIndexPaths {
        case true:
            animation = .left
        case false:
            animation = .right
        }
        
        tableView.reloadRows(at: indexPathsToReload, with: animation)
    }
    
    
    @objc func handleExpandClose(_ sender: UIButton) {
        let section = sender.tag
        var indexPaths = [IndexPath]()
        for rowIndex in allContacts[section].contacts.indices {
            indexPaths.append(IndexPath(row: rowIndex, section: section))
        }
        
        switch allContacts[section].isExpanded {
        case true:
            // close
            allContacts[section].isExpanded = false
            tableView.deleteRows(at: indexPaths, with: .top)
            sender.setTitle("Open", for: .normal)
        case false:
            // expand
            allContacts[section].isExpanded = true
            tableView.insertRows(at: indexPaths, with: .top)
            sender.setTitle("Close", for: .normal)
        }
    }
    
}

extension ViewController {
    // MARK: - SECTION METHODS -
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleExpandClose(_:)), for: .touchUpInside)
        button.tag = section
        
        return button
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allContacts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
    }
    
    
    
    // MARK: - ROW METHODS -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allContacts[section].isExpanded {
            return allContacts[section].contacts.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ContactCell else { fatalError() }
        cell.delegate = self
        let contact = allContacts[indexPath.section].contacts[indexPath.row]
        let text = showIndexPaths ? "\(contact.name), Section: \(indexPath.section), Row: \(indexPath.row)" : contact.name
        cell.textLabel?.text = text
        
        cell.accessoryView?.tintColor = contact.isFavorited ? .systemRed : .systemGray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: ContactCellDelegate {
    func contactCellFavoriteTapped(cell: ContactCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let contact = allContacts[indexPath.section].contacts[indexPath.row]
        cell.accessoryView?.tintColor = contact.isFavorited ? .systemRed : .systemGray
        allContacts[indexPath.section].contacts[indexPath.row].isFavorited.toggle()
//        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    
}
