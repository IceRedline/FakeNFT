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
        if let savedProfile = UserDefaultsService.shared.profile {
            view?.showInitialData(
                name: savedProfile.name,
                description: savedProfile.description,
                email: savedProfile.email
            )
        } else {
            view?.showInitialData(
                name: initialName,
                description: initialDescription,
                email: initialEmail
            )
        }
        
        if let image = UserDefaultsService.shared.profileImage {
            view?.setProfileImage(image)
        }
    }
    
    func saveTapped(name: String, description: String, email: String) {
        UserDefaultsService.shared.saveProfile(name: name, description: description, email: email)
        
        if let controller = view as? EditProfileController {
            let imageToSave = controller.newProfileImage ?? controller.profileImage.image
            if let image = imageToSave {
                UserDefaultsService.shared.saveProfileImage(image)
            }
        }
        
        view?.closeWithResult(name: name, description: description, email: email)
    }
    
    func changePhotoTapped() {
        view?.changeImage { [weak self] urlString in
            guard let self,
                  let urlString,
                  let url = URL(string: urlString)
            else { return }
            
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
