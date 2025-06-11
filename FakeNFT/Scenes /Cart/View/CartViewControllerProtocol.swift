//
//  CartViewControllerPresenterProtocol.swift
//  FakeNFT
//
//  Created by Артем Табенский on 06.06.2025.
//

import UIKit

protocol CartViewControllerProtocol {
    var presenter: CartPresenterProtocol? { get }
    
    func presentDeleteVC(nftImage: UIImage)
}
