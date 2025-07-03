//
//  NftCell.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 17.06.2025.
//

import UIKit

struct NftCellViewModel {
    let id: String
    let cover: URL
    let rating: Int
    let name: String
    let price: String
    let isFavorite: Bool
    let isInCart: Bool
    
    init(_ nft: NftSummary) {
        self.id = nft.id
        self.cover = nft.cover
        self.rating = nft.rating
        self.name = nft.name
        self.price = String(nft.price)
        self.isFavorite = nft.isFavorite
        self.isInCart = nft.isInCart
    }
}

final class NftCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let ratingViewToCoverSpacing: CGFloat = 8
        static let nameLabelToRatingViewSpacing: CGFloat = 5
        static let priceLabelToNameLabelSpacing: CGFloat = 4
        static let buttonSize: CGFloat = 40
    }
    
    // MARK: - Subviews
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = UIColor(resource: .ypBlack)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        label.textColor = UIColor(resource: .ypBlack)
        return label
    }()
    
    private lazy var ratingView = RatingView()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .likeOff), for: .normal)
        button.setImage(UIImage(resource: .likeOn), for: .selected)
        button.addTarget(self, action: #selector(favoriteButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(resource: .ypBlack)
        button.setImage(UIImage(resource: .cartAdd), for: .normal)
        button.setImage(UIImage(resource: .cartDelete), for: .selected)
        button.addTarget(self, action: #selector(cartButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "NftCell"
    
    // MARK: - Internal Properties
    
    var onFavoriteButtonTap: ((Bool) -> Void)?
    var onCartButtonTap: ((Bool) -> Void)?
    
    // MARK: - Private Properties
    
    private var currentImageURL: URL?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let url = currentImageURL {
            coverImageView.cancelImageLoad(for: url)
        }
        
        coverImageView.image = nil
        nameLabel.text = nil
        currentImageURL = nil
        priceLabel.text = nil
        ratingView.rating = 0
    }
    
}

// MARK: - Internal Methods

extension NftCell {
    
    func configure(with viewModel: NftCellViewModel) {
        coverImageView.loadImage(from: viewModel.cover)
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        ratingView.rating = viewModel.rating
        favoriteButton.isSelected = viewModel.isFavorite
        cartButton.isSelected = viewModel.isInCart
    }
    
}

// MARK: - Private Methods

private extension NftCell {
    
    func setupCell() {
        contentView.backgroundColor = UIColor(resource: .ypWhite)
        
        [coverImageView, ratingView, nameLabel, priceLabel, favoriteButton, cartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: Constants.ratingViewToCoverSpacing),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: Constants.nameLabelToRatingViewSpacing),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: cartButton.leadingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.priceLabelToNameLabelSpacing),
            
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            favoriteButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
            
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            cartButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
        ])
    }
    
}

// MARK: - Actions

@objc
private extension NftCell {
    
    func favoriteButtonDidTap() {
        favoriteButton.isSelected.toggle()
        onFavoriteButtonTap?(favoriteButton.isSelected)
    }
    
    func cartButtonDidTap() {
        cartButton.isSelected.toggle()
        onCartButtonTap?(cartButton.isSelected)
    }
    
}
