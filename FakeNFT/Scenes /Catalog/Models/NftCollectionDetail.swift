//
//  NftCollectionDetail.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 17.06.2025.
//

import UIKit

struct NftCollectionDetail {
    let name: String
    let description: String
    let author: String
    let cover: URL
    let nfts: [String]
}

extension NftCollectionDetail {
    
    init?(from response: NftCollectionDetailResponse) {
        guard let coverURL = URL(string: response.cover) else {
            return nil
        }
        
        self.name = response.name
        self.description = response.description
        self.author = response.author
        self.cover = coverURL
        self.nfts = response.nfts
    }
    
}
