//
//  ViewController.swift
//  Contacts App with Custom UITableView Sections
//
//  Created by Jason Pinlac on 7/13/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {
    
    let cellId = "cellId"
    var showIndexPaths = false
    
    
    
    var allContacts: [ExpandableContacts] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        configure()
        
    }
    
    
    private func fetchContacts() {
        print("Attempting to fetch contacts...")
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print(error)
                print("Failed to request access.")
                return
            }
            
            if granted {
                print("Access granted.")
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    var favoritableContacts = [FavoritableContact]()
                    try store.enumerateContacts(with: request) { (contact, stopPointerIfYouWantToStopEnumerating) in
                        let name = "\(contact.givenName) \(contact.familyName)"
                        let phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? "No Number"
                        favoritableContacts.append(FavoritableContact(name: name, phoneNumber: phoneNumber, isFavorited: false))
                    }
                    self.allContacts = [ExpandableContacts(contacts: favoritableContacts, isExpanded: true)]
                } catch {
                    print("Failed to enumerate contacts.")
                    print(error)
                }
                
            } else {
                print("Access denied..")
            }
        }
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
//        let cell = ContactCell(style: .subtitle, reuseIdentifier: cellId)
        cell.delegate = self
        let contact = allContacts[indexPath.section].contacts[indexPath.row]
        let text = showIndexPaths ? "\(contact.name), Section: \(indexPath.section), Row: \(indexPath.row)" : contact.name
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = contact.phoneNumber
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
