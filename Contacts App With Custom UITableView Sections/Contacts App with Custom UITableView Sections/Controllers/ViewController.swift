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
    
    var allNames: [ExpandableNames] = [
        ExpandableNames(names: ["Jason", "Mike", "Davy", "Gus", "TK", "Dan", "Harry", "Tyler"], isExpanded: true),
        ExpandableNames(names: ["Chico", "Giubi", "Daisy"], isExpanded: true),
        ExpandableNames(names:  ["Penny"], isExpanded: true),
        ExpandableNames(names: ["Anna", "Jose"], isExpanded: true),
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        self.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Index Path", style: .plain, target: self, action: #selector(handleShowIndexPath))
    }
    
    @objc func handleShowIndexPath() {
        var indexPathsToReload: [IndexPath] = []
        
        for section in allNames.indices {
            if allNames[section].isExpanded == false {
                continue
            }
            for row in allNames[section].names.indices {
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
        for rowIndex in allNames[section].names.indices {
            indexPaths.append(IndexPath(row: rowIndex, section: section))
        }
        
        switch allNames[section].isExpanded {
        case true:
            // close
            allNames[section].isExpanded = false
            tableView.deleteRows(at: indexPaths, with: .top)
            sender.setTitle("Open", for: .normal)
        case false:
            // expand
            allNames[section].isExpanded = true
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
        return allNames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
    }
    
    
    
// MARK: - ROW METHODS -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allNames[section].isExpanded {
            return allNames[section].names.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let name = allNames[indexPath.section].names[indexPath.row]
        
        let text = showIndexPaths ? "\(name), Section: \(indexPath.section), Row: \(indexPath.row)" : name
        cell.textLabel?.text = text
        
        return cell
    }
}
