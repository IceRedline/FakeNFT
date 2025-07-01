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
    func didTapLikeButton(at index: Int, isLiked: Bool)
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
    
    func didTapLikeButton(at index: Int, isLiked: Bool) {
        guard case let .data(viewModel) = state else { return }
        let id = viewModel.nfts[index].id
        servicesAssembly.stateService.setLike(nftId: id, isLiked: isLiked) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
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
            let errorModel = makeErrorModel(error)
            view?.showError(errorModel)
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
                        self.servicesAssembly.stateService.getLikedNfts { likedResult in
                            switch likedResult {
                            case .success(let likedIds):
                                let likedSet = Set(likedIds)
                                let summariesWithLikes = summaries.compactMap { summary in
                                    NftSummary(
                                        id: summary.id,
                                        name: summary.name,
                                        cover: summary.cover,
                                        rating: summary.rating,
                                        price: summary.price,
                                        isFavorite: likedSet.contains(summary.id),
                                        isInCart: false
                                    )
                                }
                                let fullDetail = NftCollectionDetailViewModel(collection: detail, nfts: summariesWithLikes)
                                self.state = .data(fullDetail)
                            case .failure(let error):
                                self.state = .failed(error)
                            }
                        }
                    case .failure(let error):
                        self.state = .failed(error)
                    }
                }

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
