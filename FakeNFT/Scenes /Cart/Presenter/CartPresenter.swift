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
    
    let client = DefaultNetworkClient()
    
    private let servicesAssembly: ServicesAssembly
    
    private var nftIDs: [String] = []
    private var nfts: [CartNFTModel] = []
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init()
    }
    
    func viewDidLoad() {
        loadNFTIDs()
        updateLabelsNumbers()
    }
    
    func loadNFTIDs() {
        UIBlockingProgressHUD.show()
        
        client.send(request: OrderRequest(), type: Order.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let order):
                print("Полученные NFT id: \(order)")
                self.nftIDs = order.nfts
                loadNFTsByID()
            case .failure(let error):
                print("Ошибка при загрузке ордера корзины: \(error.localizedDescription)")
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func loadNFTsByID() {
        UIBlockingProgressHUD.show()
        
        var loadedNFTs: [CartNFTModel] = []
        let group = DispatchGroup()

        for nftID in nftIDs {
            group.enter()
            
            client.send(request: NFTRequest(id: nftID), type: NFTResponse.self) { [weak self] result in
                defer { group.leave() }
                guard let self else { return }
                
                switch result {
                case .success(let nft):
                    print("✅ Полученный NFT: \(nft)")
                    
                    guard
                        let imageURL = nft.images.first,
                        let imageData = try? Data(contentsOf: imageURL),
                        let image = UIImage(data: imageData)
                    else {
                        print("⚠️ Не удалось загрузить изображение для \(nft.name)")
                        return
                    }
                    
                    let cartModel = CartNFTModel(
                        id: nft.id,
                        image: image,
                        name: nft.name,
                        rating: nft.rating,
                        price: nft.price
                    )
                    loadedNFTs.append(cartModel)
                    
                case .failure(let error):
                    print("❌ Ошибка при загрузке NFT \(nftID): \(error.localizedDescription)")
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.nfts = loadedNFTs
            self.view?.tableView.reloadData()
            self.updateLabelsNumbers()
            UIBlockingProgressHUD.dismiss()
        }
    }
    
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
    
    func updateLabelsNumbers() {
        let count = nfts.count
        let totalPrice: Double = nfts.reduce(0.0) { $0 + $1.price }
        self.view?.updateLabels(nftCount: count, totalPrice: totalPrice)
    }
    
    func checkCart() {
        nfts.isEmpty ? view?.showEmptyLabel() : view?.hideEmptyLabel()
    }
    
    func clearCart() {
        nfts.removeAll()
        view?.tableView.reloadData()
        view?.updateLabels(nftCount: 0, totalPrice: 0)
        checkCart()
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
        
        guard let index = view?.tableView.indexPath(for: cell)?.row else { return }
        let id = nftIDs[index]
        print("удаляется nft с ID: \(id)")
        
        servicesAssembly.stateService.updateCart(nftId: id, isInCart: false) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                fatalError("ошибка")
            }
        }
        
        let nftImage = cell.nftImageView.image ?? UIImage()
        
        view?.presentDeleteVC(nftImage: nftImage) { [weak self] in
            
            self?.nfts.removeAll(where: {$0.image == nftImage})
            self?.view?.tableView.reloadData()
            self?.updateLabelsNumbers()
            self?.checkCart()
        }
        print(nftIDs)
    }
}
