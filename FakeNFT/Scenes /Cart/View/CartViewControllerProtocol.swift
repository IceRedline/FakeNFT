//
//  CartViewControllerPresenterProtocol.swift
//  FakeNFT
//
//  Created by Артем Табенский on 06.06.2025.
//

import UIKit

protocol CartViewControllerProtocol {
    var presenter: CartPresenterProtocol? { get }
    var tableView: UITableView { get }
    
    func updateLabels(nftCount: Int, totalPrice: Double)
    func showEmptyLabel()
    func hideEmptyLabel()
    func presentDeleteVC(nftImage: UIImage, onConfirm: @escaping () -> Void)
}
