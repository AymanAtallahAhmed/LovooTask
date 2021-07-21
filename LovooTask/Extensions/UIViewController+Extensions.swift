//
//  UIViewController+Extensions.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/21/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit

extension UIViewController {
    func setStatusBar(color: UIColor) {
        if #available(iOS 13.0, *) {
            let statusBarView: UIView = .init()
            statusBarView.backgroundColor = color
            
            statusBarView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 20)
            view.addSubview(statusBarView)
        } else {
            let statusBar = UIApplication.shared.value(forKey: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
        }
    }
}
