//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 12.06.2025.
//

import Foundation

enum CatalogState {
    case initial, loading, failed(Error), data([Collection])
}

protocol CatalogPresenterProtocol {
    func viewDidLoad()
}

final class CatalogPresenter {
    
    // MARK: - Internal Properties
    
    weak var view: CatalogView?
    
    // MARK: - Private Properties
    
    private var state: CatalogState = .initial {
        didSet {
            stateDidChange(state)
        }
    }
    
}

// MARK: - CatalogPresenterProtocol

extension CatalogPresenter: CatalogPresenterProtocol {
    
    func viewDidLoad() {
        state = .loading
    }
    
}

// MARK: - Private Methods

private extension CatalogPresenter {
    
    func stateDidChange(_ state: CatalogState) {
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
        state = .data(Collection.mockData)
    }
    
}

