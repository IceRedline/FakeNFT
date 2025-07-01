//
//  CollectionsPresenter.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 12.06.2025.
//

import Foundation

enum CollectionsState {
    case initial, loading, failed(Error), data([NftCollectionSummary])
}

protocol CollectionsPresenterProtocol {
    func viewDidLoad()
    func sortCollectionsByName()
    func sortCollectionsByNFTCount()
    func didSelectCollection(at index: Int)
}

final class CollectionsPresenter {
    
    // MARK: - Internal Properties
    
    weak var view: CollectionsView?
    
    // MARK: - Private Properties
    
    private let collectionsService: CollectionsService
    private var state: CollectionsState = .initial {
        didSet {
            stateDidChange(state)
        }
    }
    
    // MARK: - Init
    
    init(collectionsService: CollectionsService) {
        self.collectionsService = collectionsService
    }
    
}

// MARK: - CollectionsPresenterProtocol

extension CollectionsPresenter: CollectionsPresenterProtocol {
    
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
        let input = CollectionDetailInput(id: id)
        view?.navigateToCollectionDetail(with: input)
    }
    
}

// MARK: - Private Methods

private extension CollectionsPresenter {
    
    func stateDidChange(_ state: CollectionsState) {
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
            view?.displayCells(collections.map { CollectionCellViewModel($0) })
        }
    }
    
    func loadCollections() {
        collectionsService.loadCollections { [weak self] result in
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

