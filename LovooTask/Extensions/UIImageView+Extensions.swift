//
//  UIImageView+Extensions.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/15/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit
import RxAlamofire

extension UIImageView {
    
    private var cache: NSCache<NSString, UIImage>? {
        NSCache<NSString, UIImage>()
    }
    
    func setImageWith(url: String) {
        guard let URL = URL(string: url) else { return }
        
        let cacheKey = NSString(string: url)
        if let image = self.cache?.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        _ = data(.get, URL)
            .subscribe(onNext: { [weak self] (data) in
                if let imageData = UIImage(data: data)?.jpegData(compressionQuality: 0.002) {
                    if let compressedImage = UIImage(data: imageData) {
                        self?.cache?.setObject(compressedImage, forKey: cacheKey)
                        self?.image = compressedImage
                    }
                }
            })
    }
    
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
    }
    
    @objc private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
}
