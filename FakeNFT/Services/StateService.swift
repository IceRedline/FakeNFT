//
//  StateService.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import Foundation

enum StateServiceError: Error {
    case profileNotLoaded
    case orderNotLoaded
}

typealias LikeUpdateCompletion = (Result<Void, Error>) -> Void
typealias LikedNftsCompletion = (Result<[String], Error>) -> Void

protocol StateService {
    func getLikedNfts(completion: @escaping LikedNftsCompletion)
    func setLike(nftId: String, isLiked: Bool, completion: @escaping LikeUpdateCompletion)
    func getOrder(completion: @escaping (Result<Order, Error>) -> Void)
    func updateCart(nftId: String, isInCart: Bool, completion: @escaping (Result<Order, Error>) -> Void)
}

final class DefaultStateService: StateService {

    private let networkClient: NetworkClient
    private var cachedProfile: Profile?
    private var cachedOrder: Order?
    private var likedNfts: Set<String> = []
    private var cartNfts: Set<String> = []

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        getLikedNfts { _ in }
        getOrder { _ in }
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
        
        let request = UpdateLikesRequest(id: RequestConstants.baseProfileId, likes: Array(likedNfts))

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
    
    func getOrder(completion: @escaping (Result<Order, Error>) -> Void) {
        let request = GetOrderRequest(id: RequestConstants.baseOrderId)
        
        networkClient.send(request: request, type: Order.self) { [weak self] result in
            switch result {
            case .success(let order):
                self?.cachedOrder = order
                self?.cartNfts = Set(order.nfts)
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateCart(nftId: String, isInCart: Bool, completion: @escaping (Result<Order, Error>) -> Void) {
        if isInCart {
            cartNfts.insert(nftId)
        } else {
            cartNfts.remove(nftId)
        }
        
        let request = UpdateCartRequest(id: RequestConstants.baseOrderId, nfts: Array(cartNfts))
        
        networkClient.send(request: request, type: Order.self) { [weak self] result in
            switch result {
            case .success(let order):
                self?.cachedOrder = order
                self?.cartNfts = Set(order.nfts)
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}



