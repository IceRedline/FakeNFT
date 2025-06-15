//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Anastasiia on 09.06.2025.
//

import UIKit

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
        
        if let savedData = UserDefaults.standard.dictionary(forKey: "userProfileData") {
            let name = savedData["name"] as? String ?? initialName
            let description = savedData["description"] as? String ?? initialDescription
            let email = savedData["email"] as? String ?? initialEmail
            view?.showInitialData(name: name, description: description, email: email)
        } else {
            
            view?.showInitialData(name: initialName, description: initialDescription, email: initialEmail)
        }
        
        if let imageData = UserDefaults.standard.data(forKey: "userProfileImage"),
           let image = UIImage(data: imageData) {
            view?.setProfileImage(image)
        }
    }
    
    func saveTapped(name: String, description: String, email: String) {
        
        let userData: [String: Any] = [
            "name": name,
            "description": description,
            "email": email
        ]
        UserDefaults.standard.set(userData, forKey: "userProfileData")
        
        if let controller = view as? EditProfileController {
            let imageToSave = controller.newProfileImage ?? controller.profileImage.image
            if let imageData = imageToSave?.pngData() {
                UserDefaults.standard.set(imageData, forKey: "userProfileImage")
            }
        }
        
        view?.closeWithResult(name: name, description: description, email: email)
    }
    func changePhotoTapped() {
        view?.changeImage { [weak self] urlString in
            guard let self, let urlString, let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self.view?.showError()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.view?.setProfileImage(image)
                }
            }.resume()
        }
    }
    
}



