//
//  EditProfileViewProtocol.swift
//  FakeNFT
//
//  Created by Anastasiia on 09.06.2025.
//

import Foundation

protocol EditProfileViewProtocol: AnyObject {
    func showInitialData(name: String, description: String, email: String)
    func closeWithResult(name: String, description: String, email: String)
}

