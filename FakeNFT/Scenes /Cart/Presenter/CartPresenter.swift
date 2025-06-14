//
//  CartViewControllerPresenter.swift
//  FakeNFT
//
//  Created by Артем Табенский on 06.06.2025.
//

enum SortParameter: String {
    case price
    case rating
    case name
}

import UIKit

final class CartPresenter: NSObject,
                           CartPresenterProtocol,
                           CartTableViewCellDelegate {
    
    var view: CartViewControllerProtocol?
    
    // Моковые данные, поэтому force unwrap, уберу на следующем этапе, когда будут сетевые запросы
    private var nfts: [CartNFTModel] = [
        CartNFTModel(image: UIImage(named: "testNFT1")!, name: "April", rating: 4, price: 1.78),
        CartNFTModel(image: UIImage(named: "testNFT2")!, name: "Greena", rating: 3, price: 2.23),
        CartNFTModel(image: UIImage(named: "testNFT3")!, name: "Spring", rating: 5, price: 1.05),
    ]
    
    func sort(by parameter: SortParameter) {
        switch parameter {
        case .price:
            nfts.sort(by: {$1.price > $0.price})
        case .rating:
            nfts.sort(by: {$1.rating > $0.rating})
        case .name:
            nfts.sort(by: {$1.name > $0.name})
        }
        view?.tableView.reloadData()
    }
    
    func checkCart() {
        nfts.isEmpty ? view?.showEmptyLabel() : view?.hideEmptyLabel()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { nfts.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell else {
            assertionFailure("CartPresenter - cellForRowAt: Не удалось привести ячейку к CartTableViewCell")
            return UITableViewCell()
        }
        cell.delegate = self
        
        cell.configure(nft: nfts[indexPath.row])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - CartTableViewCellDelegate
    
    func didTapDelete(for cell: CartTableViewCell) {
        let nftImage = cell.nftImageView.image ?? UIImage()
        
        view?.presentDeleteVC(nftImage: nftImage) { [weak self] in
            
            self?.nfts.removeAll(where: {$0.image == nftImage})
            self?.view?.tableView.reloadData()
            self?.checkCart()
        }
    }
}
