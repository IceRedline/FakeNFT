//
//  NFTBootstrapLoader.swift
//  FakeNFT
//
//  Created by Anastasiia on 19.06.2025.
//

import Foundation

final class NFTBootstrapLoader {
    static let shared = NFTBootstrapLoader()
    
    private init() {}
    
    func preloadAll(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        NFTService.shared.fetchMyNFTsFromOrders { nfts in
            MyNFTStorage.shared.update(nfts)
            group.leave()
        }
        
        group.enter()
        NFTService.shared.fetchFavoriteNFTs { nfts in
            let favoriteItems = nfts.map {
                FavoriteNFTModel(
                    imageURL: $0.imageName,
                    name: $0.name,
                    rating: $0.rating,
                    price: String(format: "%.2f ETH", $0.price)
                )
            }
            FavoritesStorage.shared.update(favoriteItems)
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}

