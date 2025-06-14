//
//  Collection.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 13.06.2025.
//

import UIKit

struct Collection {
    let name: String
    let cover: UIImage // TODO: заменить на url
    let nfts: [String]
    
    static let mockData = [
        Collection(
            name: "singulis epicuri",
            cover: UIImage(resource: .collection1),
            nfts: ["", "", "", "", "", ""]
        ),
        Collection(
            name: "unum reque",
            cover: UIImage(resource: .collection2),
            nfts: ["", "", "", "", "", "", "", "", "", "", "", ""]
        ),
        Collection(
            name: "quem varius",
            cover: UIImage(resource: .collection3),
            nfts: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
        ),
        Collection(
            name: "option moderatius",
            cover: UIImage(resource: .collection4),
            nfts: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
        ),
        Collection(
            name: "simul dolore",
            cover: UIImage(resource: .collection5),
            nfts: ["", ""]
        )
    ]
}
