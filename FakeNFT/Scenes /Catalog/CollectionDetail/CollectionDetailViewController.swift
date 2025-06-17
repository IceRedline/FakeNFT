//
//  CollectionDetailViewController.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 15.06.2025.
//

import UIKit

protocol CollectionDetailView: AnyObject {
    
}

final class CollectionDetailViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let imageViewHeightMultiplier: CGFloat = 0.38
        
        static let horizontalInset: CGFloat = 16
        
        static let nameLabelTopOffset: CGFloat = 16
        
        static let buttonHeight: CGFloat = 28
        static let authorInfoStackSpacing: CGFloat = 4
        static let authorInfoStackTopOffset: CGFloat = 8
        
        static let collectionViewTopOffset: CGFloat = 24
        static let collectionViewBottomInset: CGFloat = -20
        static let collectionViewMinimumInteritemSpacing: CGFloat = 10
        static let collectionViewMinimumLineSpacing: CGFloat = 8
        static let cellHeight: CGFloat = 192
    }
    
    // MARK: - Subviews
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .collection6)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Peach"
        label.font = .headline3
        label.textColor = UIColor(resource: .ypBlack)
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции:"
        label.font = .caption2
        label.textColor = UIColor(resource: .ypBlack)
        return label
    }()
    
    private lazy var authorNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("John Doe", for: .normal)
        button.setTitleColor(UIColor(resource: .ypBlue), for: .normal)
        button.titleLabel?.font = .caption1
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = .zero
        button.addTarget(self, action: #selector(authorNameButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var authorInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorLabel, authorNameButton])
        stackView.axis = .horizontal
        stackView.spacing = Constants.authorInfoStackSpacing
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
        label.font = .caption2
        label.textColor = UIColor(resource: .ypBlack)
        label.numberOfLines = .max
        label.textAlignment = .justified
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Constants.horizontalInset, bottom: 0, right: Constants.horizontalInset)
        collectionView.register(NftCell.self, forCellWithReuseIdentifier: NftCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor(resource: .ypWhite)
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private var cellModels: [NftCellViewModel] = [
        NftCellViewModel(cover: UIImage(resource: .nft1), rating: 2, name: "Archie", price: "1 ETH", isFavorite: true, isInCart: false),
        NftCellViewModel(cover: UIImage(resource: .nft2), rating: 5, name: "Ruby", price: "1 ETH", isFavorite: false, isInCart: true),
        NftCellViewModel(cover: UIImage(resource: .nft3), rating: 4, name: "Nacho", price: "1 ETH", isFavorite: true, isInCart: false),
        NftCellViewModel(cover: UIImage(resource: .nft4), rating: 3, name: "Biscuit", price: "1 ETH", isFavorite: false, isInCart: true)
    ]
    
    // MARK: - Init
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyBottomCornersRadius()
    }
    
}

// MARK: - Private Methods

private extension CollectionDetailViewController {
    
    func setupViewController() {
        view.backgroundColor = UIColor(resource: .ypWhite)
        
        [coverImageView, nameLabel, authorInfoStackView, descriptionLabel, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        authorLabel.setContentHuggingPriority(.required, for: .horizontal)
        authorLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        authorNameButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        authorNameButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coverImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Constants.imageViewHeightMultiplier),
            
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            nameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: Constants.nameLabelTopOffset),
            
            authorNameButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            authorInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            authorInfoStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.authorInfoStackTopOffset),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            descriptionLabel.topAnchor.constraint(equalTo: authorInfoStackView.bottomAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.collectionViewTopOffset),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.collectionViewBottomInset)
        ])
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        }
        
        let backButton = UIBarButtonItem(
            image: UIImage(resource: .backward),
            style: .plain,
            target: self,
            action: #selector(backButtonDidTap)
        )
        navigationItem.leftBarButtonItem = backButton
    }
    
    func applyBottomCornersRadius() {
        let path = UIBezierPath(
            roundedRect: coverImageView.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: Constants.cornerRadius, height: Constants.cornerRadius)
        )

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        coverImageView.layer.mask = mask
    }
    
}

// MARK: - Actions

@objc
private extension CollectionDetailViewController {
    
    func backButtonDidTap() {
        
    }
    
    func authorNameButtonDidTap() {
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension CollectionDetailViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        cellModels.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NftCell.reuseIdentifier,
                for: indexPath
            ) as? NftCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: cellModels[indexPath.row])
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.bounds.width - Constants.horizontalInset * 2 - Constants.collectionViewMinimumInteritemSpacing * 2
        let cellWidth = availableWidth / 3
        return CGSize(width: cellWidth, height: Constants.cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        Constants.collectionViewMinimumInteritemSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        Constants.collectionViewMinimumLineSpacing
    }
    
}
