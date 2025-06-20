//
//  MyNFTCell.swift
//  FakeNFT
//
//  Created by Anastasiia on 13.06.2025.
//

import UIKit

final class MyNFTCell: UITableViewCell {
    static let reuseIdentifier = "MyNFTCell"
    
    private let nftImage = UIImageView()
    private let nameLabel = UILabel()
    private let creatorPrefixLabel = UILabel()
    private let creatorNameLabel = UILabel()
    private let stars = UIStackView()
    private let priceLabel = UILabel()
    private let priceValueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nftImage.translatesAutoresizingMaskIntoConstraints = false
        nftImage.layer.cornerRadius = 12
        nftImage.clipsToBounds = true
        nftImage.contentMode = .scaleAspectFill
        contentView.addSubview(nftImage)
        
        NSLayoutConstraint.activate([
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            nftImage.heightAnchor.constraint(equalToConstant: 108)
        ])
        
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nameLabel.textColor = UIColor(named: "Black")
        
        creatorPrefixLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        creatorPrefixLabel.textColor = UIColor(named: "Black")
        
        creatorNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        creatorNameLabel.textColor = UIColor(named: "Black")
        
        let creatorStack = UIStackView(arrangedSubviews: [creatorPrefixLabel, creatorNameLabel])
        creatorStack.axis = .horizontal
        creatorStack.spacing = 4
        
        stars.axis = .horizontal
        stars.spacing = 2
        stars.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.text = "Цена"
        priceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        priceLabel.textColor = UIColor(named: "Black")
        
        priceValueLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        priceValueLabel.textColor = UIColor(named: "Black")
        
        let textStack = UIStackView(arrangedSubviews: [nameLabel, stars, creatorStack])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        let priceStack = UIStackView(arrangedSubviews: [priceLabel, priceValueLabel])
        priceStack.axis = .vertical
        priceStack.alignment = .leading
        priceStack.spacing = 4
        priceStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(textStack)
        contentView.addSubview(priceStack)
        
        NSLayoutConstraint.activate([
            textStack.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 16),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: priceStack.leadingAnchor, constant: -12),
            
            priceStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with nft: NFTModel) {
        loadImage(from: nft.imageName)
        nameLabel.text = nft.name
        creatorPrefixLabel.text = "от"
        creatorNameLabel.text = nft.creator
        priceValueLabel.text = String(format: "%.2f ETH", nft.price)
        updateStars(rating: nft.rating)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            nftImage.image = UIImage(systemName: "photo") // заглушка
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
        stars.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 1...5 {
            let starImage = UIImage(systemName: i <= rating ? "star.fill" : "star")
            let imageView = UIImageView(image: starImage)
            imageView.tintColor = UIColor(named: "yellowUniversal")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            stars.addArrangedSubview(imageView)
        }
    }
}

