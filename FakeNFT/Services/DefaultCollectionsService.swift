//
//  DefaultCollectionsService.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import Foundation

typealias CollectionsGetCompletion = (Result<[NftCollectionSummaryResponse], Error>) -> Void

protocol CollectionsService {
    func loadCollections(completion: @escaping CollectionsGetCompletion)
}

final class DefaultCollectionsService: CollectionsService {
    
    private let client: NetworkClient

    init(client: NetworkClient = DefaultNetworkClient()) {
        self.client = client
    }

    func loadCollections(completion: @escaping CollectionsGetCompletion) {
        let request = CollectionsRequest()
        client.send(request: request, type: [NftCollectionSummaryResponse].self, onResponse: completion)
    }
}

