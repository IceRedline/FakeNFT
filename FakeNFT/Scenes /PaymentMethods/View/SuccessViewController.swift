//
//  SuccessViewController.swift
//  FakeNFT
//
//  Created by Артем Табенский on 07.06.2025.
//

import UIKit

class SuccessViewController: UIViewController {

    private let successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "successImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(named: "ypBlack") ?? .black
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вернуться в каталог", for: .normal)
        button.backgroundColor = UIColor(named: "ypBlack") ?? .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ypWhite")
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(successImageView)
        view.addSubview(successLabel)
        view.addSubview(returnButton)
        
        NSLayoutConstraint.activate([
            successImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 196),
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.widthAnchor.constraint(equalToConstant: 278),
            successImageView.heightAnchor.constraint(equalToConstant: 278),
            
            successLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 32),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            returnButton.heightAnchor.constraint(equalToConstant: 60),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func backButtonTapped() {
        let servicesAssembly = ServicesAssembly(networkClient: DefaultNetworkClient(),nftStorage: NftStorageImpl())
        let tabBar = TabBarController(servicesAssembly: servicesAssembly)
        tabBar.modalPresentationStyle = .fullScreen
        tabBar.modalTransitionStyle = .crossDissolve
        tabBar.selectedIndex = 1
        present(tabBar, animated: true)
    }

}

#Preview(traits: .defaultLayout, body: {
    SuccessViewController()
})
