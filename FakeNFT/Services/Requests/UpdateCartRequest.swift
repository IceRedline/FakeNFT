//
//  UpdateCartRequest.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import Foundation

struct UpdateCartRequest: NetworkRequest {
    let id: String
    let nfts: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
    
    var httpMethod: HttpMethod { .put }
    
    var dto: Dto? {
        UpdateCartDto(nfts: nfts)
    }
}

struct UpdateCartDto: Dto {
    let nfts: [String]
    
    func asDictionary() -> [String: String] {
        ["nfts": nfts.joined(separator: ",")]
    }
}

