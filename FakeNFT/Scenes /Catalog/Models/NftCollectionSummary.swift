//
//  NftCollectionSummary.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 13.06.2025.
//

import UIKit

struct NftCollectionSummary {
    let id: String
    let name: String
    let cover: URL
    let nftCount: Int
    let createdAt: Date
}

extension NftCollectionSummary {
    init?(from response: NftCollectionSummaryResponse) {
        guard
            let coverURL = URL(string: response.cover),
            let date = DateFormatter.defaultDateFormatter.date(from: response.createdAt)
        else {
            return nil
        }
        
        self.id = response.id
        self.name = response.name
        self.cover = coverURL
        self.nftCount = response.nfts.count
        self.createdAt = date
    }
}
