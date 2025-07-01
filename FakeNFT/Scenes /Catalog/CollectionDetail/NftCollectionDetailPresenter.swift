//
//  NftCollectionDetailPresenter.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 17.06.2025.
//

import Foundation

enum NftCollectionDetailState {
    case initial, loading, failed(Error), data(NftCollectionDetailViewModel)
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
    
    private let servicesAssembly: ServicesAssembly
    private let input: NftCollectionDetailInput
    private var state: NftCollectionDetailState = .initial {
        didSet {
            stateDidChange(state)
        }
    }
    
    // MARK: - Init
    
    init(servicesAssembly: ServicesAssembly, input: NftCollectionDetailInput) {
        self.servicesAssembly = servicesAssembly
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
        case .data(let viewModel):
            view?.hideLoading()
            view?.displayDetails(viewModel)
        }
    }
    
    func loadDetails() {
        servicesAssembly.collectionService.loadCollection(by: input.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let detail = NftCollectionDetail(from: response) else {
                    self.state = .failed(NetworkClientError.parsingError)
                    return
                }
                
                self.servicesAssembly.nftService.loadNftSummaries(by: detail.nfts) { summariesResult in
                    switch summariesResult {
                    case .success(let summaries):
                        let fullDetail = NftCollectionDetailViewModel(collection: detail, nfts: summaries)
                        self.state = .data(fullDetail)
                    case .failure(let error):
                        self.state = .failed(error)
                    }
                }
                
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
    
}
