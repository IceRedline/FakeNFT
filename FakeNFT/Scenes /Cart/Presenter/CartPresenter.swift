//
//  CartViewControllerPresenter.swift
//  FakeNFT
//
//  Created by Артем Табенский on 06.06.2025.
//

import UIKit

class CartPresenter: NSObject, CartPresenterProtocol {
    
    var view: CartViewControllerProtocol?
    
    let nfts: [CartNFTModel] = [
        CartNFTModel(image: UIImage(named: "testNFT1")!, name: "April", rating: 1, price: 1.78),
        CartNFTModel(image: UIImage(named: "testNFT2")!, name: "Greena", rating: 3, price: 1.78),
        CartNFTModel(image: UIImage(named: "testNFT3")!, name: "Spring", rating: 5, price: 1.78),
    ]
    
    func viewDidLoad() {
        
    }
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nfts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell else {
            fatalError("CartPresenter - cellForRowAt: Не удалось привести ячейку к CartTableViewCell")
        }
        
        cell.configure(nft: nfts[indexPath.row])
        
        return cell
    }
    
}
