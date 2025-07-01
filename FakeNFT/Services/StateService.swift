//
//  StateService.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import Foundation

enum StateServiceError: Error {
    case profileNotLoaded
}

typealias LikeUpdateCompletion = (Result<Void, Error>) -> Void
typealias LikedNftsCompletion = (Result<[String], Error>) -> Void

protocol StateService {
    func getLikedNfts(completion: @escaping LikedNftsCompletion)
    func setLike(nftId: String, isLiked: Bool, completion: @escaping LikeUpdateCompletion)
    func isLiked(nftId: String) -> Bool
}

final class DefaultStateService: StateService {

    private let networkClient: NetworkClient
    private var cachedProfile: Profile?
    private var likedNfts: Set<String> = []

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        getLikedNfts { _ in }
    }

    func getLikedNfts(completion: @escaping LikedNftsCompletion) {
        let request = GetProfileRequest(id: RequestConstants.baseProfileId)

        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.cachedProfile = profile
                self?.likedNfts = Set(profile.likes)
                completion(.success(profile.likes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func setLike(nftId: String, isLiked: Bool, completion: @escaping LikeUpdateCompletion) {
        if isLiked {
            likedNfts.insert(nftId)
        } else {
            likedNfts.remove(nftId)
        }
        
        let request = UpdateProfileRequest(id: RequestConstants.baseProfileId, likes: Array(likedNfts))

        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.cachedProfile = profile
                self?.likedNfts = Set(profile.likes)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func isLiked(nftId: String) -> Bool {
        likedNfts.contains(nftId)
    }
    
}



