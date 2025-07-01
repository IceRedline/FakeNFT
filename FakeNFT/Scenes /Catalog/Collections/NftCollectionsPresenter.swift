//
//  NftCollectionsPresenter.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 12.06.2025.
//

import Foundation

enum NftCollectionsState {
    case initial, loading, failed(Error), data([NftCollectionSummary])
}

protocol NftCollectionsPresenterProtocol {
    func viewDidLoad()
    func sortCollectionsByName()
    func sortCollectionsByNFTCount()
    func didSelectCollection(at index: Int)
}

final class NftCollectionsPresenter {
    
    // MARK: - Internal Properties
    
    weak var view: NftCollectionsView?
    
    // MARK: - Private Properties
    
    private let collectionService: NftCollectionService
    private var state: NftCollectionsState = .initial {
        didSet {
            stateDidChange(state)
        }
    }
    
    // MARK: - Init
    
    init(collectionsService: NftCollectionService) {
        self.collectionService = collectionsService
    }
    
}

// MARK: - CollectionsPresenterProtocol

extension NftCollectionsPresenter: NftCollectionsPresenterProtocol {
    
    func viewDidLoad() {
        state = .loading
    }
    
    func sortCollectionsByName() {
        
    }
    
    func sortCollectionsByNFTCount() {
        
    }
    
    func didSelectCollection(at index: Int) {
        guard case let .data(collections) = state else { return }
        let id = collections[index].id
        let input = NftCollectionDetailInput(id: id)
        view?.navigateToCollectionDetail(with: input, collectionService: collectionService)
    }
    
}

// MARK: - Private Methods

private extension NftCollectionsPresenter {
    
    func stateDidChange(_ state: NftCollectionsState) {
        switch state {
        case .initial:
            assertionFailure("Initial state")
        case .loading:
            view?.showLoading()
            loadCollections()
        case .failed(let error):
            view?.hideLoading()
            print(error.localizedDescription)
            // TODO: show error
        case .data(let collections):
            view?.hideLoading()
            view?.displayCells(collections.map { NftCollectionCellViewModel($0) })
        }
    }
    
    func loadCollections() {
        collectionService.loadCollections { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let collections):
                self.state = .data(collections.compactMap { NftCollectionSummary(from: $0) })
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
    
}

