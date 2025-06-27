//
//  NftCollectionSummary.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 13.06.2025.
//

import UIKit

struct NftCollectionSummary {
    let name: String
    let cover: UIImage // TODO: заменить на url
    let nftCount: Int
    
    static let mockData = [
        NftCollectionSummary(
            name: "singulis epicuri",
            cover: UIImage(resource: .collection1),
            nftCount: 9
        ),
        NftCollectionSummary(
            name: "unum reque",
            cover: UIImage(resource: .collection2),
            nftCount: 4
        ),
        NftCollectionSummary(
            name: "quem varius",
            cover: UIImage(resource: .collection3),
            nftCount: 7
        ),
        NftCollectionSummary(
            name: "option moderatius",
            cover: UIImage(resource: .collection4),
            nftCount: 11
        ),
        NftCollectionSummary(
            name: "simul dolore",
            cover: UIImage(resource: .collection5),
            nftCount: 2
        )
    ]
}
