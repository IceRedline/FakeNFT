//
//  NftCollectionService.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import Foundation

typealias NftCollectionsGetCompletion = (Result<[NftCollectionSummaryResponse], Error>) -> Void
typealias NftCollectionGetCompletion = (Result<NftCollectionDetailResponse, Error>) -> Void

protocol NftCollectionService {
    func loadCollections(completion: @escaping NftCollectionsGetCompletion)
    func loadCollection(by id: String, completion: @escaping NftCollectionGetCompletion)
}

final class DefaultNftCollectionService: NftCollectionService {
    
    private let client: NetworkClient

    init(client: NetworkClient = DefaultNetworkClient()) {
        self.client = client
    }

    func loadCollections(completion: @escaping NftCollectionsGetCompletion) {
        let request = NftCollectionSummariesRequest()
        client.send(request: request, type: [NftCollectionSummaryResponse].self, onResponse: completion)
    }
    
    func loadCollection(by id: String, completion: @escaping NftCollectionGetCompletion) {
        let request = NftCollectionDetailRequest(collectionId: id)
        client.send(request: request, type: NftCollectionDetailResponse.self, onResponse: completion)
    }
    
}

