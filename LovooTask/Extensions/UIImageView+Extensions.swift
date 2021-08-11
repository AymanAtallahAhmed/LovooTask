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
    
    func setImageWith(url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        var cgImage: CGImage?
        let backgroundQueue: DispatchQueue = .init(label: "Lovoo")
        let maxDimentionInPixels = max(bounds.size.width,
                                       bounds.size.height) * UIScreen.main.scale
        let backgroundWorkItem = DispatchWorkItem.init(qos: .userInteractive, flags: .assignCurrentContext) { [weak self] in
            self?.getCGImageFor(url: imageURL, dimention: maxDimentionInPixels) { image in
                cgImage = image
            }
        }
        
        backgroundWorkItem.notify(queue: .main) { [weak self] in
            guard let self = self,
                let cgImage = cgImage else { return }
            self.image = UIImage.init(cgImage: cgImage)
        }
        
        backgroundQueue.async(execute: backgroundWorkItem)
    }
    
    
    private func getCGImageFor(url: URL, dimention: CGFloat, completion: @escaping (CGImage) -> Void) {
        let imageSourceOptions = [kCGImageSourceShouldCache: true] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, imageSourceOptions) else { return }
        
        let downSampledOptions = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCache: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: dimention*1.4
            ] as CFDictionary
        
        guard let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampledOptions) else { return }
        completion(downSampledImage)
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
