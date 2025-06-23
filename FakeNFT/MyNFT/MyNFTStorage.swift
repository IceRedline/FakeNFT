//
//  MyNFTStorage.swift
//  FakeNFT
//
//  Created by Anastasiia on 18.06.2025.
//

import Foundation

final class MyNFTStorage {
    static let shared = MyNFTStorage()
    
    private init() {}
    
    private(set) var nfts: [NFTModel] = []
    
    func update(_ nfts: [NFTModel]) {
        self.nfts = nfts
    }
}
