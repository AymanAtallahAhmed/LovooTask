//
//  ImageCell.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/15/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    var stringURL: String? {
        didSet {
            imageView.setImageWith(url: stringURL ?? "")
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    typealias CellAction = (UIImageView) -> ()
    var imageViewDidTap: CellAction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(imageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
    }

    @objc private func imageViewTapped() {
        imageViewDidTap?(imageView)
    }
}
