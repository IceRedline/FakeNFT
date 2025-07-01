import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias NftSummariesCompletion = (Result<[NftSummary], Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func loadNftSummaries(by ids: [String], completion: @escaping NftSummariesCompletion)
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadNftSummaries(by ids: [String], completion: @escaping NftSummariesCompletion) {
        var summaries: [NftSummary] = []
        var errors: [Error] = []
        let group = DispatchGroup()
        
        for id in ids {
            group.enter()
            loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    if let summary = NftSummary(from: nft) {
                        summaries.append(summary)
                    } else {
                        completion(.failure(NetworkClientError.parsingError))
                    }
                case .failure(let error):
                    errors.append(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if !errors.isEmpty && summaries.isEmpty {
                completion(.failure(errors[0]))
            } else {
                completion(.success(summaries))
            }
        }
    }
    
}
