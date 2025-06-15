//
//  NftCollection.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 13.06.2025.
//

import UIKit

struct NftCollection {
    let name: String
    let cover: UIImage // TODO: заменить на url
    let nfts: [String]
    
    static let mockData = [
        NftCollection(
            name: "singulis epicuri",
            cover: UIImage(resource: .collection1),
            nfts: ["", "", "", "", "", ""]
        ),
        NftCollection(
            name: "unum reque",
            cover: UIImage(resource: .collection2),
            nfts: ["", "", "", "", "", "", "", "", "", "", "", ""]
        ),
        NftCollection(
            name: "quem varius",
            cover: UIImage(resource: .collection3),
            nfts: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
        ),
        NftCollection(
            name: "option moderatius",
            cover: UIImage(resource: .collection4),
            nfts: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
        ),
        NftCollection(
            name: "simul dolore",
            cover: UIImage(resource: .collection5),
            nfts: ["", ""]
        )
    ]
}
