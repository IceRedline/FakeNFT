//
//  RatingView.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 17.06.2025.
//

import UIKit

final class RatingView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let starSize: CGFloat = 12
        static let starSpacing: CGFloat = 2
        static let starCount: Int = 5
    }
    
    // MARK: - Internal Properties
    
    var rating: Int = 0 {
        didSet {
            updateStars()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let width = CGFloat(Constants.starCount) * Constants.starSize +
                    CGFloat(Constants.starCount - 1) * Constants.starSpacing
        let height = Constants.starSize
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Private Properties
    
    private var starImageViews: [UIImageView] = []
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStars()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStars()
    }
    
    // MARK: - Private Methods
    
    private func setupStars() {
        for _ in 0..<Constants.starCount {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor(resource: .ypLightGray)
            imageView.image = UIImage(systemName: "star")
            addSubview(imageView)
            starImageViews.append(imageView)
        }
        
        for (index, imageView) in starImageViews.enumerated() {
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: Constants.starSize),
                imageView.heightAnchor.constraint(equalToConstant: Constants.starSize),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            
            if index == 0 {
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: starImageViews[index - 1].trailingAnchor, constant: Constants.starSpacing).isActive = true
            }
            
            if index == Constants.starCount - 1 {
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            }
        }
        
        updateStars()
    }
    
    private func updateStars() {
        for (index, imageView) in starImageViews.enumerated() {
            imageView.image = UIImage(systemName: index < rating ? "star.fill" : "star")
            imageView.tintColor = UIColor(resource: index < rating ? .ypYellow : .ypLightGray)
        }
    }
    
}
