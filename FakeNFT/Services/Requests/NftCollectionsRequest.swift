//
//  NftCollectionsRequest.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import Foundation

struct NftCollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}

struct NftCollectionSummaryResponse: Decodable {
    let id: String
    let name: String
    let cover: String
    let nfts: [String]
    let createdAt: String
}
