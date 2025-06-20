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
    private let starsCount = UIStackView()
    private let likeButton = UIButton()
    
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
        likeButton.setImage(UIImage(named: "like"), for: .normal)
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
        
        starsCount.axis = .horizontal
        starsCount.spacing = 2
        starsCount.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(starsCount)
        
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
            
            starsCount.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            starsCount.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: starsCount.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
    
    @objc private func likeTapped() {
        onLikeTapped?()
    }
    
    func configure(with item: FavoriteNFTModel) {
        loadImage(from: item.imageURL)
        nameLabel.text = item.name
        priceLabel.text = item.price
        updateStars(rating: item.rating)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            nftImage.image = UIImage(systemName: "photo")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.nftImage.image = image
            }
        }.resume()
    }
    
    
    private func updateStars(rating: Int) {
        starsCount.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 1...5 {
            let imageName = i <= rating ? "star.fill" : "star"
            let imageView = UIImageView(image: UIImage(systemName: imageName))
            imageView.tintColor = UIColor(named: "yellowUniversal")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            starsCount.addArrangedSubview(imageView)
        }
    }
}
