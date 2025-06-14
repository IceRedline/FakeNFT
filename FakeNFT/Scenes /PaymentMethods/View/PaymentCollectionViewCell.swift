//
//  PaymentCollectionViewCell.swift
//  FakeNFT
//
//  Created by Артем Табенский on 07.06.2025.
//

import UIKit

final class PaymentCollectionViewCell: UICollectionViewCell {
    
    lazy var currencyImageView = UIImageView()
    lazy var currencyNameLabel = UILabel()
    lazy var currencyTickerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .ypLightGray
        contentView.layer.cornerRadius = Constants.corner12
        [currencyImageView, currencyNameLabel, currencyTickerLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        currencyImageView.layer.cornerRadius = 6
        currencyNameLabel.font = UIFont.systemFont(ofSize: 13)
        currencyNameLabel.textColor = .ypBlack
        currencyTickerLabel.font = UIFont.systemFont(ofSize: 13)
        currencyTickerLabel.textColor = .ypGreen
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currencyImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            currencyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            currencyImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            currencyImageView.widthAnchor.constraint(equalToConstant: 36),
            currencyNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            currencyNameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            currencyTickerLabel.topAnchor.constraint(equalTo: currencyNameLabel.bottomAnchor, constant: 0),
            currencyTickerLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
        ])
    }
    
    func configure(currency: CurrencyModel) {
        guard let image = UIImage(named: currency.imageName) else { return }
        currencyImageView.image = image
        currencyNameLabel.text = currency.name
        currencyTickerLabel.text = currency.ticker
    }
    
}
