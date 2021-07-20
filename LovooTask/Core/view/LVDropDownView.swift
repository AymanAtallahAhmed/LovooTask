//
//  LVDropDownView.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/17/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit

protocol LVDropDownViewDelegate: class {
    func dropDownPressed(title: String)
}

class LVDropDownView: UIView {
    
    var options = [String]()
    var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    weak var delegate: LVDropDownViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension LVDropDownView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.textColor = .label
        cell.backgroundColor = .systemGray2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.dropDownPressed(title: options[indexPath.row])
    }
}
