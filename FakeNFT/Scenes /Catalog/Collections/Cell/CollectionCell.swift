//
//  CollectionCell.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 13.06.2025.
//

import UIKit

struct CollectionCellViewModel {
    let name: String
    let nftsCount: String
    let cover: UIImage
    
    init(_ collection: NftCollection) {
        self.name = collection.name
        self.nftsCount = String(collection.nfts.count)
        self.cover = collection.cover
    }
}

final class CollectionCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let coverHeight: CGFloat = 140
        static let cornerRadius: CGFloat = 12
        static let labelTopOffset: CGFloat = 4
    }
    
    // MARK: - Subviews
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var nameAndCountLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = UIColor(resource: .ypBlack)
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
    
}

// MARK: - Internal Methods

extension CollectionCell {
    
    func configure(with viewModel: CollectionCellViewModel) {
        coverImageView.image = viewModel.cover
        nameAndCountLabel.text = "\(viewModel.name) (\(viewModel.nftsCount))"
    }
    
}

// MARK: - Private Methods

private extension CollectionCell {
    
    func setupCell() {
        contentView.backgroundColor = UIColor(resource: .ypWhite)
        
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
            nameAndCountLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: Constants.labelTopOffset)
        ])
    }
    
}
