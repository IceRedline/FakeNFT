//
//  StarRating.swift
//  FakeNFT
//
//  Created by Anastasiia on 22.06.2025.
//

import UIKit

enum StarRating {
    static func makeStars(rating: Int, color: UIColor = UIColor(named: "yellowUniversal") ?? .systemYellow, size: CGFloat = 12) -> [UIImageView] {
        return (1...5).map { i in
            let imageName = i <= rating ? "star.fill" : "star"
            let imageView = UIImageView(image: UIImage(systemName: imageName))
            imageView.tintColor = color
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
            return imageView
        }
    }
}
