//
//  PaymentCollectionViewCell.swift
//  FakeNFT
//
//  Created by Артем Табенский on 07.06.2025.
//

import UIKit

class PaymentCollectionViewCell: UICollectionViewCell {
    
    var currencyImageView = UIImageView()
    var currencyNameLabel = UILabel()
    var currencyTickerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(named: "ypLightGray")
        contentView.layer.cornerRadius = 12
        [currencyImageView, currencyNameLabel, currencyTickerLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }
        
        currencyImageView.layer.cornerRadius = 6
        currencyNameLabel.font = UIFont.systemFont(ofSize: 13)
        currencyNameLabel.textColor = UIColor(named: "ypBlack")
        currencyTickerLabel.font = UIFont.systemFont(ofSize: 13)
        currencyTickerLabel.textColor = UIColor(named: "ypGreen")
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
        currencyImageView.image = currency.image
        currencyNameLabel.text = currency.name
        currencyTickerLabel.text = currency.ticker
    }
    
}
