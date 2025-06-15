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
        static let authorStackSpacing: CGFloat = 4
        static let authorStackTopOffset: CGFloat = 8
        static let collectionViewTopOffset: CGFloat = 24
        static let collectionViewBottomInset: CGFloat = -20
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
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Doe"
        label.font = .caption1
        label.textColor = UIColor(resource: .ypBlue)
        return label
    }()
    
    private lazy var authorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorLabel, authorNameLabel])
        stackView.axis = .horizontal
        stackView.spacing = Constants.authorStackSpacing
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
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
        
        [coverImageView, nameLabel, authorStackView, descriptionLabel/*, collectionView*/].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        authorLabel.setContentHuggingPriority(.required, for: .horizontal)
        authorLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        authorNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        authorNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coverImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Constants.imageViewHeightMultiplier),
            
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            nameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: Constants.nameLabelTopOffset),
            
            authorStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            authorStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            authorStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.authorStackTopOffset),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            descriptionLabel.topAnchor.constraint(equalTo: authorStackView.bottomAnchor)//,
            
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
//            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.collectionViewTopOffset),
//            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.collectionViewBottomInset)
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
    
}
