//
//  CurrenciesRequest.swift
//  FakeNFT
//
//  Created by Артем Табенский on 19.06.2025.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {

    var httpMethod: HttpMethod { .get }
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
    
    var dto: Dto? { nil }
}
