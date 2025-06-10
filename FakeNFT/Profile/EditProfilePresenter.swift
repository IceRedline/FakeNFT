//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Anastasiia on 09.06.2025.
//

import Foundation

final class EditProfilePresenter {
    weak var view: EditProfileViewProtocol?
    
    private let initialName: String
    private let initialDescription: String
    private let initialEmail: String

    init(view: EditProfileViewProtocol, name: String, description: String, email: String) {
        self.view = view
        self.initialName = name
        self.initialDescription = description
        self.initialEmail = email
    }

    func viewDidLoad() {
        view?.showInitialData(name: initialName, description: initialDescription, email: initialEmail)
    }

    func saveTapped(name: String, description: String, email: String) {
        view?.closeWithResult(name: name, description: description, email: email)
    }
}



