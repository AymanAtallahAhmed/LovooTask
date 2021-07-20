//
//  UITableView+Extensions.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/15/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit

extension UITableView {
    /**
     registering cell with only it's nib name
     */
    func registerNIB<Cell: UITableViewCell>(cell: Cell.Type) {
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellReuseIdentifier: String(describing: Cell.self))
    }
}
