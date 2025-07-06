//
//  GetProfileRequest.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import Foundation

struct GetProfileRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }

    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}
