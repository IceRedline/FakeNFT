//
//  UpdateProfileRequest.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    let id: String
    let likes: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }

    var httpMethod: HttpMethod { .put }

    var dto: Dto? {
        UpdateLikesDto(likes: likes)
    }
}

struct UpdateLikesDto: Dto {
    let likes: [String]

    func asDictionary() -> [String: String] {
        ["likes": likes.joined(separator: ",")]
    }
}
