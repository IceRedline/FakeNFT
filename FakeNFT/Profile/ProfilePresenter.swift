//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Anastasiia on 09.06.2025.
//

import UIKit

final class ProfilePresenter {
    weak var view: ProfileProtocol?
    
    private let nftCount: Int
    
    init(view: ProfileProtocol, nftCount: Int) {
        self.view = view
        self.nftCount = nftCount
    }
    
    func viewDidLoad() {
        
        let savedData = UserDefaults.standard.dictionary(forKey: "userProfileData")
        
        let name = savedData?["name"] as? String ?? "Joaquin Phoenix"
        let description = savedData?["description"] as? String ?? "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        let email = savedData?["email"] as? String ?? "Joaquin Phoenix.com"
        
        var profileImage: UIImage? = UIImage(named: "profile")
        if let imageData = UserDefaults.standard.data(forKey: "userProfileImage"),
           let image = UIImage(data: imageData) {
            profileImage = image
        }
        
        if savedData == nil {
            let defaultData: [String: Any] = [
                "name": name,
                "description": description,
                "email": email
            ]
            UserDefaults.standard.set(defaultData, forKey: "userProfileData")
        }
        
        let profile = Profile(
            name: name,
            description: description,
            email: email,
            nftCount: [
                ("Мои NFT", "\(nftCount)"),
                ("Избранные NFT", "11"),
                ("О разработчике", nil)
            ],
            image: profileImage
        )
        
        view?.setupProfile(profile)
    }
}
