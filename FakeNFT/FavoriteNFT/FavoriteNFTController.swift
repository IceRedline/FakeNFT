//
//  favoriteNFT.swift
//  FakeNFT
//
//  Created by Anastasiia on 09.06.2025.
//

import UIKit

protocol FavoriteNFTControllerDelegate: AnyObject {
    func favoriteNFTController(_ controller: FavoriteNFTController, didUpdateFavoriteCount count: Int)
}

final class FavoriteNFTController: UIViewController, FavoriteNFTProtocol {
    
    weak var delegate: FavoriteNFTControllerDelegate?
    
    private lazy var presenter = FavoriteNFTPresenter(view: self)
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет избранных NFT"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupActivityIndicator()
        activityIndicator.startAnimating()
        presenter.viewDidLoad()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        view.addSubview(emptyStateLabel)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .white
        collectionView.register(FavoriteNFTCell.self, forCellWithReuseIdentifier: FavoriteNFTCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension FavoriteNFTController {
    func updateCollection() {
        collectionView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func showEmptyState() {
        emptyStateLabel.isHidden = false
        collectionView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func hideEmptyState() {
        emptyStateLabel.isHidden = true
        collectionView.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func updateTitle(_ title: String?) {
        navigationItem.title = title
    }
    
    func notifyFavoriteCountChanged(_ count: Int) {
        delegate?.favoriteNFTController(self, didUpdateFavoriteCount: count)
    }
}

extension FavoriteNFTController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < presenter.numberOfItems(),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteNFTCell.identifier, for: indexPath) as? FavoriteNFTCell else {
            return UICollectionViewCell()
        }
        
        let item = presenter.item(at: indexPath.item)
        cell.configure(with: item)
        
        cell.onLikeTapped = { [weak self, weak cell] in
            guard let self = self,
                  let cell = cell,
                  let indexPath = collectionView.indexPath(for: cell) else { return }
            
            self.presenter.removeItem(at: indexPath.item)
        }
        
        return cell
    }
}

extension FavoriteNFTController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168, height: 80)
    }
}
