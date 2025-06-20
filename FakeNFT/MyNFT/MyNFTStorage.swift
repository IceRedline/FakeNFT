//
//  MyNFTStorage.swift
//  FakeNFT
//
//  Created by Anastasiia on 18.06.2025.
//

import Foundation

final class MyNFTStorage {
    static let shared = MyNFTStorage()
    var nfts: [NFTModel] = []
    
    func update(_ nfts: [NFTModel]) {
        self.nfts = nfts
    }
}
