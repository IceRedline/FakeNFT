//
//  NFTmodel.swift
//  FakeNFT
//
//  Created by Anastasiia on 13.06.2025.
//

import Foundation

struct NFTModel {
    let imageName: String
    let name: String
    let rating: Int
    let creator: String
    let price: Double
}

struct NFTResponse: Decodable {
    let id: String
    let name: String
    let images: [URL]
    let author: String
    let rating: Int
    let price: Double
}

