//
//  CurrenciesRequest.swift
//  FakeNFT
//
//  Created by Артем Табенский on 19.06.2025.
//

import Foundation

struct OrderRequest: NetworkRequest {

    var httpMethod: HttpMethod { .get }
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var dto: Dto? { nil }
}
