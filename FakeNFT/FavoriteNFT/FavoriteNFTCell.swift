//
//  FavoriteNFTCell.swift
//  FakeNFT
//
//  Created by Anastasiia on 18.06.2025.
//

import UIKit

final class FavoriteNFTCell: UICollectionViewCell {
    static let identifier = "NFTCell"
    
    private let nftImage = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let likeButton = UIButton()
    private let stars = UIStackView()
    
    var onLikeTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        nftImage.translatesAutoresizingMaskIntoConstraints = false
        nftImage.contentMode = .scaleAspectFill
        nftImage.layer.cornerRadius = 12
        nftImage.clipsToBounds = true
        contentView.addSubview(nftImage)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(resource: .like), for: .normal)
        likeButton.imageView?.contentMode = .scaleAspectFit
        contentView.addSubview(likeButton)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        priceLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        priceLabel.textColor = .black
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        
        stars.axis = .horizontal
        stars.spacing = 2
        stars.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stars)
        
        NSLayoutConstraint.activate([
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImage.widthAnchor.constraint(equalToConstant: 80),
            nftImage.heightAnchor.constraint(equalToConstant: 80),
            
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.topAnchor.constraint(equalTo:  nftImage.topAnchor, constant: -6),
            likeButton.trailingAnchor.constraint(equalTo:  nftImage.trailingAnchor, constant: 5),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            nameLabel.leadingAnchor.constraint(equalTo:  nftImage.trailingAnchor, constant: 12),
            
            stars.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            stars.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
    
    @objc private func likeTapped() {
        onLikeTapped?()
    }
    
    func configure(with item: FavoriteNFTModel) {
        nameLabel.text = item.name
        priceLabel.text = item.price
        updateStars(rating: item.rating)
        
        ImageLoader.shared.loadImage(from: item.imageURL) { [weak self] image in
            self?.nftImage.image = image ?? UIImage(systemName: "photo")
        }
    }
    
    private func updateStars(rating: Int) {
        stars.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let views = StarRating.makeStars(rating: rating)
        views.forEach { stars.addArrangedSubview($0) }
    }
}
