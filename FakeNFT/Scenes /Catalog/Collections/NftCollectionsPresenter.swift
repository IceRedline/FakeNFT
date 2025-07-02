//
//  NftCollectionsPresenter.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 12.06.2025.
//

import Foundation

enum NftCollectionsState {
    case initial
    case loading
    case failed(Error)
    case data([NftCollectionSummary])
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
    
    private let servicesAssembly: ServicesAssembly
    private var state: NftCollectionsState = .initial {
        didSet {
            stateDidChange(state)
        }
    }
    
    // MARK: - Init
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
}

// MARK: - CollectionsPresenterProtocol

extension NftCollectionsPresenter: NftCollectionsPresenterProtocol {
    
    func viewDidLoad() {
        state = .loading
    }
    
    func sortCollectionsByName() {
        guard case let .data(collections) = state else { return }
        let sorted = collections.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        state = .data(sorted)
    }

    func sortCollectionsByNFTCount() {
        guard case let .data(collections) = state else { return }
        let sorted = collections.sorted { $0.nftCount > $1.nftCount }
        state = .data(sorted)
    }
    
    func didSelectCollection(at index: Int) {
        guard case let .data(collections) = state else { return }
        let id = collections[index].id
        let input = NftCollectionDetailInput(id: id)
        view?.navigateToCollectionDetail(with: input, servicesAssembly: servicesAssembly)
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
            let errorModel = makeErrorModel(error)
            view?.showError(errorModel)
        case .data(let collections):
            view?.hideLoading()
            view?.displayCells(collections.map { NftCollectionCellViewModel($0) })
        }
    }
    
    func loadCollections() {
        servicesAssembly.collectionService.loadCollections { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let collections):
                self.state = .data(collections.compactMap { NftCollectionSummary(from: $0) })
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
    
    func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
    
}

