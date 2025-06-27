//
//  NftCollection.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 17.06.2025.
//

import UIKit

struct NftCollection {
    let name: String
    let description: String
    let author: String
    let cover: UIImage // TODO: заменить на url
    let nfts: [NftSummary] // TODO: заменить на [id]
    
    static let mockData: NftCollection = NftCollection(
        name: "Peach",
        description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.",
        author: "John Doe",
        cover: UIImage(resource: .collection6),
        nfts: [
            
        ]
    )
}
