//
//  UIImageView+ImageLoading.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import UIKit

extension UIImageView {
    
    private static let loader = NftImageLoader()
    
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        image = placeholder
        
        Self.loader.loadImage(from: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.image = image
            case .failure:
                break
            }
        }
    }
    
    func cancelImageLoad(for url: URL) {
        Self.loader.cancelLoad(for: url)
    }
    
}
