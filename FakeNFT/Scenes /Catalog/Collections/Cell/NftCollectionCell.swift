//
//  NftCollectionCell.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 13.06.2025.
//

import UIKit

struct NftCollectionCellViewModel {
    let name: String
    let nftCount: String
    let cover: URL
    
    init(_ collection: NftCollectionSummary) {
        self.name = collection.name
        self.nftCount = String(collection.nftCount)
        self.cover = collection.cover
    }
}

final class NftCollectionCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let coverHeight: CGFloat = 140
        static let cornerRadius: CGFloat = 12
        static let labelTopOffset: CGFloat = 4
        static let bottomOffset: CGFloat = 8
    }
    
    // MARK: - Private Properties
    
    private var currentImageURL: URL?
    
    // MARK: - Subviews
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(resource: .ypLightGray) // placeholder цвет
        return imageView
    }()
    
    private lazy var nameAndCountLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = UIColor(resource: .ypBlack)
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "CollectionCell"
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        nameAndCountLabel.text = nil
        currentImageURL = nil
    }
}

// MARK: - Internal Methods

extension NftCollectionCell {
    
    func configure(with viewModel: NftCollectionCellViewModel) {
        currentImageURL = viewModel.cover
        coverImageView.loadImage(from: viewModel.cover)
        nameAndCountLabel.text = "\(viewModel.name) (\(viewModel.nftCount))"
    }
}

// MARK: - Private Methods

private extension NftCollectionCell {
    
    func setupCell() {
        backgroundColor = UIColor(resource: .ypWhite)
        selectionStyle = .none
        
        [coverImageView, nameAndCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: Constants.coverHeight),
            
            nameAndCountLabel.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            nameAndCountLabel.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            nameAndCountLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: Constants.labelTopOffset),
            nameAndCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomOffset)
        ])
    }
}
