//
//  CollectionDetailPresenter.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 17.06.2025.
//

import Foundation

enum CollectionDetailState {
    case initial, loading, failed(Error), data(NftCollection)
}

struct CollectionDetailInput {
    let id: String
}

protocol CollectionDetailPresenterProtocol {
    func viewDidLoad()
}

final class CollectionDetailPresenter {
    
    // MARK: - Internal Properties
    
    weak var view: CollectionDetailView?
    
    // MARK: - Private Properties
    
    private let input: CollectionDetailInput
    private var state: CollectionDetailState = .initial {
        didSet {
            stateDidChange(state)
        }
    }
    
    // MARK: - Init
    
    init(input: CollectionDetailInput) {
        self.input = input
    }
    
}

// MARK: - CollectionDetailPresenterProtocol

extension CollectionDetailPresenter: CollectionDetailPresenterProtocol {
    
    func viewDidLoad() {
        state = .loading
    }
    
}

// MARK: - Private Methods

private extension CollectionDetailPresenter {
    
    func stateDidChange(_ state: CollectionDetailState) {
        switch state {
        case .initial:
            assertionFailure("initial state")
        case .loading:
            view?.showLoading()
            loadDetails()
        case .failed(let error):
            view?.hideLoading()
            // TODO: show error
        case .data(let summary):
            view?.hideLoading()
            view?.displayDetails(CollectionDetailViewModel(summary))
        }
    }
    
    func loadDetails() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.state = .data(NftCollection.mockData)
        }
    }
    
}
