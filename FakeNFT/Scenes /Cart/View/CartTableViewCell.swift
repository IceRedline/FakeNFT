//
//  ConverterTableViewCell.swift
//  AirConverter
//
//  Created by Артем Табенский on 27.05.2025.
//

import UIKit

final class CartTableViewCell: UITableViewCell {
    
    var nftImageView = UIImageView()
    var nftNameLabel = UILabel()
    var starsImageView = UIImageView()
    let priceLabel = UILabel()
    var priceAmountLabel = UILabel()
    let deleteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [nftImageView, nftNameLabel, starsImageView, priceLabel, priceAmountLabel, deleteButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }
        
        nftImageView.layer.cornerRadius = Constants.corner12
        nftNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nftNameLabel.textColor = .ypBlack
        priceLabel.text = "Цена"
        priceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        priceLabel.textColor = .ypBlack
        priceAmountLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        priceAmountLabel.textColor = .ypBlack
        deleteButton.setImage(UIImage(named: "deleteFromCart"), for: .normal)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            nftNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            starsImageView.heightAnchor.constraint(equalToConstant: 12),
            starsImageView.widthAnchor.constraint(equalToConstant: 68),
            starsImageView.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 6),
            starsImageView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: starsImageView.bottomAnchor, constant: 15),
            priceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            priceAmountLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            priceAmountLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(nft: CartNFTModel) {
        nftImageView.image = nft.image
        nftNameLabel.text = nft.name
        let imageName = String(nft.rating) + "stars"
        starsImageView.image = UIImage(named: imageName)
        priceAmountLabel.text = "\(nft.price) ETH"
    }
    
    @objc func currencyNameButtonTapped(_ sender: UIButton) {
        // TODO: -
    }
}
