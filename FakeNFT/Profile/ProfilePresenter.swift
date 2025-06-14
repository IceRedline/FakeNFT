//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Anastasiia on 09.06.2025.
//

import Foundation

final class ProfilePresenter {
    weak var view: ProfileProtocol?

    init(view: ProfileProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        let profile = Profile(
            name: "Joaquin Phoenix",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            email: "Joaquin Phoenix.com",
            nftCount: [
                ("Мои NFT", "112"),
                ("Избранные NFT", "11"),
                ("О разработчике", nil)
            ]
        )
        view?.setupProfile(profile)
    }
}
