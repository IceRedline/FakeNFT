//
//  PaymentViewControllerProtocol.swift
//  FakeNFT
//
//  Created by Артем Табенский on 07.06.2025.
//

import Foundation

protocol PaymentViewControllerProtocol {
    var presenter: PaymentPresenterProtocol? { get }
    
    func showPaymentError()
}
