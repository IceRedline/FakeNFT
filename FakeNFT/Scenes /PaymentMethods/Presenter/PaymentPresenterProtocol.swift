//
//  PaymentPresenterProtocol.swift
//  FakeNFT
//
//  Created by Артем Табенский on 07.06.2025.
//

import UIKit

protocol PaymentPresenterProtocol: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    var view: PaymentViewControllerProtocol? { get set }
    
    func viewDidLoad()
}
