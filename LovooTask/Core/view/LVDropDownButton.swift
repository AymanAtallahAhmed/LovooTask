//
//  LVDropDownButton.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/17/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit

class LVDropDownButton: UIButton {
        
    lazy private var dropView = LVDropDownView()
    private var height = NSLayoutConstraint()
    private var isOpen = false
    private var isActive = true
    
    var itemSelectedCompletion: ((String) -> ())?
    var options: [String]? {
        didSet {
            dropView.options = options ?? []
            dropView.tableView.reloadData()
        }
    }
    
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
        contentHorizontalAlignment = .center
        setTitleColor(.label, for: .normal)
        dropView.delegate = self
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        
        if isActive {
            NSLayoutConstraint.activate([
                dropView.topAnchor.constraint(equalTo: self.bottomAnchor),
                dropView.centerXAnchor.constraint(equalTo: centerXAnchor),
                dropView.widthAnchor.constraint(equalTo: widthAnchor),
            ])
            height = dropView.heightAnchor.constraint(equalToConstant: 0)
            isActive = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isOpen {
            isOpen = true
            NSLayoutConstraint.deactivate([height])
            
            height.constant = dropView.tableView.contentSize.height > 160 ?
                160 : dropView.tableView.contentSize.height
            
            self.superview?.bringSubviewToFront(dropView)
            NSLayoutConstraint.activate([height])
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height/2
            })
        } else {
            dismissDropDown()
        }
    }
    
    private func dismissDropDown() {
        isOpen = false
        height.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height/2
            self.dropView.layoutIfNeeded()
        })
        
        NSLayoutConstraint.deactivate([
            dropView.topAnchor.constraint(equalTo: self.bottomAnchor),
            dropView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dropView.widthAnchor.constraint(equalTo: widthAnchor),
            height
        ])
    }
}

extension LVDropDownButton: LVDropDownViewDelegate {
    func dropDownPressed(title: String) {
        setTitle(title, for: .normal)
        itemSelectedCompletion?(title)
        dismissDropDown()
    }
}
