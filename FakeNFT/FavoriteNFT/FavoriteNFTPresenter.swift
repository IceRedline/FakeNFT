//
//  FavoriteNFTPresenter.swift
//  FakeNFT
//
//  Created by Anastasiia on 18.06.2025.
//

import Foundation

final class FavoriteNFTPresenter {
    weak var view: FavoriteNFTProtocol?
    
    private(set) var items: [FavoriteNFTModel] = []
    
    init(view: FavoriteNFTProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        NFTService.shared.fetchFavoriteNFTs { [weak self] nfts in
            guard let self = self else { return }
            
            self.items = nfts.map {
                FavoriteNFTModel(
                    imageURL: $0.imageName,
                    name: $0.name,
                    rating: $0.rating,
                    price: String(format: "%.2f ETH", $0.price)
                )
            }
            
            FavoritesStorage.shared.update(items)
            
            DispatchQueue.main.async {
                if self.items.isEmpty {
                    self.view?.showEmptyState()
                    self.view?.updateTitle(nil)
                } else {
                    self.view?.hideEmptyState()
                    self.view?.updateTitle("Избранные NFT")
                }
                
                self.view?.notifyFavoriteCountChanged(self.items.count)
                self.view?.updateCollection()
            }
        }
    }
    
    func numberOfItems() -> Int {
        items.count
    }
    
    func item(at index: Int) -> FavoriteNFTModel {
        items[index]
    }
    
    func removeItem(at index: Int) {
        guard index < items.count else { return }
        items.remove(at: index)
        FavoritesStorage.shared.update(items)
        
        DispatchQueue.main.async {
            self.view?.updateCollection()
            self.view?.notifyFavoriteCountChanged(self.items.count)
            
            if self.items.isEmpty {
                self.view?.showEmptyState()
                self.view?.updateTitle(nil)
            }
        }
    }
}

