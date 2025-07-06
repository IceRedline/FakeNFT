//
//  AuthorWebPresenter.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 27.06.2025.
//

import Foundation

protocol AuthorWebPresenterProtocol {
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}

final class AuthorWebPresenter {
    
    // MARK: - Internal Properties
    
    weak var view: AuthorWebView?
    
    // MARK: - Private Properties
    
    private let requestBuilder: AuthorWebRequestBuilder
    
    // MARK: - Init

    init(requestBuilder: AuthorWebRequestBuilder) {
        self.requestBuilder = requestBuilder
    }
    
}

// MARK: - AuthorWebPresenterProtocol

extension AuthorWebPresenter: AuthorWebPresenterProtocol {
    
    func viewDidLoad() {
        let request = requestBuilder.makeRequest()
        view?.load(for: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        view?.setProgressValue(Float(newValue))
        view?.setProgressHidden(newValue >= 1.0)
    }
}
