//
//  NftCollectionDetailPresenter.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 17.06.2025.
//

import Foundation

enum NftCollectionDetailState {
    case initial, loading, failed(Error), data(NftCollectionDetail)
}

struct NftCollectionDetailInput {
    let id: String
}

protocol NftCollectionDetailPresenterProtocol {
    func viewDidLoad()
    func didTapAuthorButton()
}

final class NftCollectionDetailPresenter {
    
    // MARK: - Internal Properties
    
    weak var view: NftCollectionDetailView?
    
    // MARK: - Private Properties
    
    private let collectionService: NftCollectionService
    private let input: NftCollectionDetailInput
    private var state: NftCollectionDetailState = .initial {
        didSet {
            stateDidChange(state)
        }
    }
    
    // MARK: - Init
    
    init(collectionService: NftCollectionService, input: NftCollectionDetailInput) {
        self.collectionService = collectionService
        self.input = input
    }
    
}

// MARK: - CollectionDetailPresenterProtocol

extension NftCollectionDetailPresenter: NftCollectionDetailPresenterProtocol {
    
    func viewDidLoad() {
        state = .loading
    }
    
    func didTapAuthorButton() {
        view?.navigateToAuthorWebViewController()
    }
    
}

// MARK: - Private Methods

private extension NftCollectionDetailPresenter {
    
    func stateDidChange(_ state: NftCollectionDetailState) {
        switch state {
        case .initial:
            assertionFailure("Initial state")
        case .loading:
            view?.showLoading()
            loadDetails()
        case .failed(let error):
            view?.hideLoading()
            // TODO: show error
        case .data(let summary):
            view?.hideLoading()
            view?.displayDetails(NftCollectionDetailViewModel(summary))
        }
    }
    
    func loadDetails() {
        collectionService.loadCollection(by: input.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let detail = NftCollectionDetail(from: response) {
                    self.state = .data(detail)
                } else {
                    self.state = .failed(NetworkClientError.parsingError)
                }
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
    
}
