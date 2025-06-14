//
//  EditProfileViewProtocol.swift
//  FakeNFT
//
//  Created by Anastasiia on 09.06.2025.
//

import UIKit

protocol EditProfileViewProtocol: AnyObject {
    func showInitialData(name: String, description: String, email: String)
    func closeWithResult(name: String, description: String, email: String)
    func setProfileImage(_ image: UIImage)
    func changeImage(completion: @escaping (String?) -> Void)
    func showError()
}

