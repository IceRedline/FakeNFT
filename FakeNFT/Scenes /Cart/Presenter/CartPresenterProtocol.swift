//
//  CartPresenterProtocol.swift
//  FakeNFT
//
//  Created by Артем Табенский on 06.06.2025.
//

import UIKit

protocol CartPresenterProtocol: UITableViewDelegate, UITableViewDataSource {
    var view: CartViewControllerProtocol? { get set }
    
    func viewDidLoad()
}
