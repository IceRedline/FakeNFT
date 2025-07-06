//
//  NFTService.swift
//  FakeNFT
//
//  Created by Anastasiia on 19.06.2025.
//

import Foundation

final class NFTService {
    static let shared = NFTService()
    
    private init() {}
    
    private let token = "d8d620c3-90df-46d8-bea8-694c831cf0b3"
    private let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1"
    
    func fetchNFTIDsFromProfile(completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "\(baseURL)/profile/1") else {
            completion([])
            return
        }
        let request = makeRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let ids = json["nfts"] as? [String] else {
                print("Не удалось получить nfts из профиля")
                completion([])
                return
            }
            completion(ids)
        }.resume()
    }
    
    func fetchNFT(by id: String, completion: @escaping (NFTModel?) -> Void) {
        guard let url = URL(string: "\(baseURL)/nft/\(id)") else {
            completion(nil)
            return
        }
        let request = makeRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data else {
                completion(nil)
                return
            }
            do {
                let decoded = try JSONDecoder().decode(NFTResponse.self, from: data)
                let imageUrl = decoded.images.first?.absoluteString ?? ""
                let extractedName = self.extractNameFromURL(imageUrl) ?? decoded.name
                
                let model = NFTModel(
                    imageName: imageUrl,
                    name: extractedName,
                    rating: decoded.rating,
                    creator: decoded.author,
                    price: decoded.price
                )
                completion(model)
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchNFTs(for ids: [String], completion: @escaping ([NFTModel]) -> Void) {
        let group = DispatchGroup()
        var result: [NFTModel] = []
        
        for id in ids {
            group.enter()
            fetchNFT(by: id) { nft in
                if let nft = nft {
                    result.append(nft)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(result)
        }
    }
    
    func fetchFavoriteNFTs(completion: @escaping ([NFTModel]) -> Void) {
        guard let url = URL(string: "\(baseURL)/profile/1") else {
            completion([])
            return
        }
        let request = makeRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data else {
                print("Нет данных")
                completion([])
                return
            }
            
            if let raw = String(data: data, encoding: .utf8) {
                print("Ответ от сервера: \(raw)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let ids = json["likes"] as? [String] {
                    print("Лайки: \(ids)")
                    self.fetchNFTs(for: ids, completion: completion)
                } else {
                    print("likes не найден или формат другой")
                    completion([])
                }
            } catch {
                print("Ошибка JSON: \(error)")
                completion([])
            }
        }.resume()
    }
    
    func fetchMyNFTsFromOrders(completion: @escaping ([NFTModel]) -> Void) {
        guard let url = URL(string: "\(baseURL)/orders/1") else {
            completion([])
            return
        }
        let request = makeRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let ids = json["nfts"] as? [String] else {
                completion([])
                return
            }
            self.fetchNFTs(for: ids, completion: completion)
        }.resume()
    }
    
    private func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        return request
    }
    
    private func extractNameFromURL(_ urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }
        let components = url.pathComponents
        if let nftIndex = components.firstIndex(of: "NFT"), nftIndex + 1 < components.count {
            return components[nftIndex + 1]
        }
        return nil
    }
}
