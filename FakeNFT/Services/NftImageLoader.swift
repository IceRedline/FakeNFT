//
//  NftImageLoader.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 01.07.2025.
//

import UIKit

enum NftImageLoaderError: Error {
    case invalidData
    case cancelledDownload
}

protocol NftImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
    func cancelLoad(for url: URL)
}

final class NftImageLoader: NftImageLoaderProtocol {
    
    // MARK: - Private Properties
    
    private let cache = NSCache<NSString, UIImage>()
    private var activeTasks: [URL: URLSessionDataTask] = [:]
    private let queue = DispatchQueue(label: "ImageLoader", qos: .utility)
    
    // MARK: - NftImageLoaderProtocol
    
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let key = url.absoluteString as NSString
        
        if let cachedImage = cache.object(forKey: key) {
            DispatchQueue.main.async {
                completion(.success(cachedImage))
            }
            return
        }
        
        cancelLoad(for: url)
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.activeTasks.removeValue(forKey: url)
            }
            
            if let error = error as? URLError, error.code == .cancelled {
                DispatchQueue.main.async {
                    completion(.failure(NftImageLoaderError.cancelledDownload))
                }
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(NftImageLoaderError.invalidData))
                }
                return
            }
            
            self?.cache.setObject(image, forKey: key)
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        
        activeTasks[url] = task
        task.resume()
    }
    
    func cancelLoad(for url: URL) {
        activeTasks[url]?.cancel()
        activeTasks.removeValue(forKey: url)
    }
}

