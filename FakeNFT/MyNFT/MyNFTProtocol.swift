//
//  MyNFTProtocol.swift
//  FakeNFT
//
//  Created by Anastasiia on 13.06.2025.
//

import Foundation

protocol MyNFTViewProtocol: AnyObject {
    func setupNFT(_ nfts: [NFT])
    func showSortOptions()
}
