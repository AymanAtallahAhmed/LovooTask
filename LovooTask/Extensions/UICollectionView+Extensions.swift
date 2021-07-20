//
//  UICollectionView+Extensions.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/15/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    /// register the collectionView cell with only it's Nib name
    func registerNIB<Cell: UICollectionViewCell>(_: Cell.Type) {
        let identifier = String(describing: Cell.self)
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    /// dequeue the cell to the collectionView with it's Nib name and the current indexpath
    func dequeue<Cell: UICollectionViewCell>(cell: Cell.Type, for index: IndexPath) -> Cell {
        let identifier = String(describing: cell.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: index) as? Cell else {
            fatalError("Unable to Dequeue Reusable Collection View Cell with identifier: \(identifier)")
        }
        return cell
    }
}
