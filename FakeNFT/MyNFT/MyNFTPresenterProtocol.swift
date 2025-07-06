//
//  MyNFTPresenterProtocol.swift
//  FakeNFT
//
//  Created by Anastasiia on 13.06.2025.
//

import Foundation

protocol MyNFTPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSort()
    func sort(by option: SortOption)
}
