//
//  UIView+Extensions.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/16/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit

extension UIView {
    func setView(corner: CGFloat) {
        layer.cornerRadius = corner
        clipsToBounds = true
        
        layer.borderWidth = 1
        layer.borderColor = backgroundColor?.cgColor
    }
}
