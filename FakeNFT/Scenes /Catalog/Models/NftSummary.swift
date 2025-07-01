//
//  NftSummary.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 17.06.2025.
//

import UIKit

struct NftSummary {
    let id: String
    let name: String
    let cover: URL
    let rating: Int
    let price: Float
}

extension NftSummary {
    
    init?(from nft: Nft) {
        self.id = nft.id
        self.name = nft.name
        self.cover = nft.images[0]
        self.rating = nft.rating
        self.price = nft.price
    }
    
}
