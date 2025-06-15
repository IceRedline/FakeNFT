//
//  CollectionsPresenter.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 12.06.2025.
//

import Foundation

enum CollectionsState {
    case initial, loading, failed(Error), data([NftCollection])
}

protocol CollectionsPresenterProtocol {
    func viewDidLoad()
    func sortCollectionsByName()
    func sortCollectionsByNFTCount()
}

final class CollectionsPresenter {
    
    // MARK: - Internal Properties
    
    weak var view: CollectionsView?
    
    // MARK: - Private Properties
    
    private var state: CollectionsState = .initial {
        didSet {
            stateDidChange(state)
        }
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
    
}

// MARK: - Private Methods

private extension CollectionsPresenter {
    
    func stateDidChange(_ state: CollectionsState) {
        switch state {
        case .initial:
            assertionFailure("initial state")
        case .loading:
            view?.showLoading()
            loadCollections()
        case .failed(let error):
            view?.hideLoading()
            // TODO: show error
        case .data(let collections):
            view?.hideLoading()
            view?.showCells(collections.map { CollectionCellViewModel($0) })
        }
    }
    
    func loadCollections() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.state = .data(NftCollection.mockData)
        }
    }
    
}

