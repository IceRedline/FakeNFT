//
//  NftCollectionDetailRequest.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import Foundation

struct NftCollectionDetailRequest: NetworkRequest {
    let collectionId: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(collectionId)")
    }
    
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}

struct NftCollectionDetailResponse: Decodable {
    let id: String
    let name: String
    let description: String
    let cover: String
    let author: String
    let nfts: [String]
}
