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
    let cover: UIImage // TODO: заменить на url
    let nftCount: Int
    
    static let mockData = [
        NftCollectionSummary(
            id: "1",
            name: "singulis epicuri",
            cover: UIImage(resource: .collection1),
            nftCount: 9
        ),
        NftCollectionSummary(
            id: "2",
            name: "unum reque",
            cover: UIImage(resource: .collection2),
            nftCount: 4
        ),
        NftCollectionSummary(
            id: "3",
            name: "quem varius",
            cover: UIImage(resource: .collection3),
            nftCount: 7
        ),
        NftCollectionSummary(
            id: "4",
            name: "option moderatius",
            cover: UIImage(resource: .collection4),
            nftCount: 11
        ),
        NftCollectionSummary(
            id: "5",
            name: "simul dolore",
            cover: UIImage(resource: .collection5),
            nftCount: 2
        )
    ]
}
