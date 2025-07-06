//
//  UserDefaultsProfileService.swift
//  FakeNFT
//
//  Created by Anastasiia on 15.06.2025.
//

import UIKit

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    private enum Keys {
        static let profileData = "userProfileData"
        static let profileImage = "userProfileImage"
    }
    
    var profile: (name: String, description: String, email: String)? {
        guard let data = defaults.dictionary(forKey: Keys.profileData) else { return nil }
        let name = data["name"] as? String ?? ""
        let description = data["description"] as? String ?? ""
        let email = data["email"] as? String ?? ""
        return (name, description, email)
    }
    
    func saveProfile(name: String, description: String, email: String) {
        let data: [String: Any] = [
            "name": name,
            "description": description,
            "email": email
        ]
        defaults.set(data, forKey: Keys.profileData)
    }
    
    var profileImage: UIImage? {
        guard let imageData = defaults.data(forKey: Keys.profileImage) else { return nil }
        return UIImage(data: imageData)
    }
    
    func saveProfileImage(_ image: UIImage) {
        if let imageData = image.pngData() {
            defaults.set(imageData, forKey: Keys.profileImage)
        }
    }
}
