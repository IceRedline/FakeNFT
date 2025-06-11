//
//  CartTableViewCellDelegate.swift
//  FakeNFT
//
//  Created by Артем Табенский on 11.06.2025.
//

import Foundation

protocol CartTableViewCellDelegate: AnyObject {
    func didTapDelete(for cell: CartTableViewCell)
}
