//
//  NftCollectionDetailViewController.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 15.06.2025.
//

import UIKit

struct NftCollectionDetailViewModel {
    let cover: URL
    let name: String
    let author: String
    let description: String
    let nfts: [NftCellViewModel]
    
    init(collection: NftCollectionDetail, nfts: [NftSummary]) {
        self.cover = collection.cover
        self.name = collection.name
        self.author = collection.author
        self.description = collection.description
        self.nfts = nfts.map { NftCellViewModel($0) }
    }
    
}

protocol NftCollectionDetailView: AnyObject, LoadingView, ErrorView {
    func displayDetails(_ viewModel: NftCollectionDetailViewModel)
    func navigateToAuthorWebViewController()
}

final class NftCollectionDetailViewController: UIViewController {
    
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
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .gray
        return activityIndicator
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
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
        button.setTitleColor(UIColor(resource: .ypBlue), for: .normal)
        button.titleLabel?.font = .caption1
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = .zero
        button.addTarget(self, action: #selector(didTapAuthorNameButton), for: .touchUpInside)
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
    
    private let presenter: NftCollectionDetailPresenterProtocol
    private var cellModels: [NftCellViewModel] = []
    
    // MARK: - Init
    
    init(_ presenter: NftCollectionDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyBottomCornersRadius()
    }
    
}

// MARK: - CollectionDetailView

extension NftCollectionDetailViewController: NftCollectionDetailView {
    
    func displayDetails(_ viewModel: NftCollectionDetailViewModel) {
        coverImageView.loadImage(from: viewModel.cover)
        nameLabel.text = viewModel.name
        authorNameButton.setTitle(viewModel.author, for: .normal)
        descriptionLabel.text = viewModel.description
        cellModels = viewModel.nfts
    
        collectionView.reloadData()
    }
    
    func navigateToAuthorWebViewController() {
        let requestBuilder = DefaultAuthorWebRequestBuilder()
        let presenter = AuthorWebPresenter(requestBuilder: requestBuilder)
        let viewController = AuthorWebViewController(presenter: presenter)
        presenter.view = viewController
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - Private Methods

private extension NftCollectionDetailViewController {
    
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
            action: #selector(didTapBackButton)
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
private extension NftCollectionDetailViewController {
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapAuthorNameButton() {
        presenter.didTapAuthorButton()
    }
    
}

// MARK: - UICollectionViewDataSource

extension NftCollectionDetailViewController: UICollectionViewDataSource {
    
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
        cell.onFavoriteButtonTap = { [weak self] isFavorite in
            self?.presenter.didTapLikeButton(at: indexPath.row, isLiked: isFavorite)
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NftCollectionDetailViewController: UICollectionViewDelegateFlowLayout {
    
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
