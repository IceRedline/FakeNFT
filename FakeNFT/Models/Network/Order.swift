//
//  Order.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import Foundation

struct Order: Decodable {
    let id: String
    let nfts: [String]
}
