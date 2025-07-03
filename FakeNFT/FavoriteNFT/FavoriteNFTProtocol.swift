//
//  FavoriteNFTProtocol.swift
//  FakeNFT
//
//  Created by Anastasiia on 18.06.2025.
//

import Foundation

protocol FavoriteNFTProtocol: AnyObject {
    func updateCollection()
    func showEmptyState()
    func hideEmptyState()
    func updateTitle(_ title: String?)
    func notifyFavoriteCountChanged(_ count: Int)
}

