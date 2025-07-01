//
//  DefaultNftCollectionsService.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import Foundation

typealias NftCollectionsGetCompletion = (Result<[NftCollectionSummaryResponse], Error>) -> Void

protocol NftCollectionsService {
    func loadCollections(completion: @escaping NftCollectionsGetCompletion)
}

final class DefaultNftCollectionsService: NftCollectionsService {
    
    private let client: NetworkClient

    init(client: NetworkClient = DefaultNetworkClient()) {
        self.client = client
    }

    func loadCollections(completion: @escaping NftCollectionsGetCompletion) {
        let request = NftCollectionsRequest()
        client.send(request: request, type: [NftCollectionSummaryResponse].self, onResponse: completion)
    }
}

