//
//  FavoritesStorage.swift
//  FakeNFT
//
//  Created by Anastasiia on 18.06.2025.
//

import Foundation

final class FavoritesStorage {
    static let shared = FavoritesStorage()
    var favorites: [FavoriteNFTModel] = []
    
    func update(_ favorites: [FavoriteNFTModel]) {
        self.favorites = favorites
    }
}
