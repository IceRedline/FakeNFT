//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Артем Табенский on 07.06.2025.
//

import UIKit
import ProgressHUD

final class PaymentPresenter: NSObject, PaymentPresenterProtocol {
    
    var view: PaymentViewControllerProtocol?
    
    let client = DefaultNetworkClient()
    
    var currencies: [CurrencyModel] = []
    
    func viewDidLoad() {
        loadCurrencies()
    }
    
    func loadCurrencies() {
        UIBlockingProgressHUD.show()
        
        client.send(request: CurrenciesRequest(), type: [CurrencyModel].self) { result in
            switch result {
            case .success(let currencies):
                print("Полученные валюты: \(currencies)")
                self.currencies = currencies
                self.view?.collectionView.reloadData()
                UIBlockingProgressHUD.dismiss()
                
            case .failure(let error):
                print("Ошибка при загрузке валют: \(error.localizedDescription)")
            }
        }
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { currencies.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentCollectionViewCell", for: indexPath) as? PaymentCollectionViewCell else {
            fatalError("Не удалось привести ячейку к типу PaymentCollectionViewCell")
        }
        
        cell.configure(currency: currencies[indexPath.row])
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PaymentCollectionViewCell else { return }
        cell.layer.borderColor = UIColor.ypBlack.cgColor
        cell.layer.cornerRadius = Constants.corner12
        UIView.animate(withDuration: 0.2) {
            cell.layer.borderWidth = 1
        }
        
        view?.enablePayButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PaymentCollectionViewCell else { return }
        UIView.animate(withDuration: 0.2) {
            cell.layer.borderWidth = 0
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2 - 20, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 24, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 42)
    }
    
}
