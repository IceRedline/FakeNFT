//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Anastasiia on 13.06.2025.
//

import Foundation

enum SortOption {
    case price
    case rating
    case name
}

final class MyNFTPresenter: MyNFTPresenterProtocol {
    private weak var view: MyNFTViewProtocol?
    private var nfts: [NFTModel] = []
    
    init(view: MyNFTViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        NFTService.shared.fetchMyNFTsFromOrders { [weak self] nfts in
            self?.nfts = nfts
            self?.view?.setupNFT(nfts)
        }
    }
    
    func didTapSort() {
        view?.showSortOptions()
    }
    
    func sort(by option: SortOption) {
        switch option {
        case .price:
            nfts.sort { $0.price < $1.price }
        case .rating:
            nfts.sort { $0.rating > $1.rating }
        case .name:
            nfts.sort { $0.name.localizedCompare($1.name) == .orderedAscending }
        }
        view?.setupNFT(nfts)
    }
}
