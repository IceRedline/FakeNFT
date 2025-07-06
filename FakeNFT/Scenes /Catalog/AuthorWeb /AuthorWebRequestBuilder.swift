//
//  AuthorWebRequestBuilder.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 28.06.2025.
//

import Foundation

protocol AuthorWebRequestBuilder {
    func makeRequest() -> URLRequest
}

struct DefaultAuthorWebRequestBuilder: AuthorWebRequestBuilder {
    private let url = URL(string: "https://practicum.yandex.ru/ios-developer/?from=catalog")!
    
    func makeRequest() -> URLRequest {
        URLRequest(url: url)
    }
}
