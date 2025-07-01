import Foundation

struct Nft: Decodable {
    let id: String
    let name: String
    let rating: Int
    let price: Float
    let images: [URL]
}
