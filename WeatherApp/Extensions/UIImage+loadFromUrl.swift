//
//  UIImage+loadFromUrl.swift
//  WeatherApp
//
//  Created by Reshma Unnikrishnan on 21.08.19.
//  Copyright © 2019 ruvlmoon. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFromUrl(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func animateImagesUrls(urls: [URL?]) {
        DispatchQueue.global().async { [weak self] in
            var images: [UIImage] = []
            urls.forEach({ (url) in
                if let url = url, let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        images.append(image)
                    }
                }
            })
            
            DispatchQueue.main.async {
                self?.animationImages = images
                self?.animationDuration = 1.0
                self?.startAnimating()
            }
        }
    }
}
