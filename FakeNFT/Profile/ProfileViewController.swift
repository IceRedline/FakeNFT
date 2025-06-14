//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Anastasiia on 09.06.2025.
//

import UIKit

final class ProfileViewController: UIViewController, MyNFTControllerDelegate {
    func myNFTController(_ controller: MyNFTController, didUpdateNFTCount count: Int) {
        self.myNFT = Array(repeating: NFT(imageName: "NFT", name: "", rating: 0, creator: "", price: 0), count: count)
        self.presenter = ProfilePresenter(view: self, nftCount: count)
        self.presenter?.viewDidLoad()
    }


    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let emailLabel = UILabel()
    private let tableView = UITableView()
    private var presenter: ProfilePresenter?
    private var nftCount: [(String, String?)] = []
    let profileImage = UIImageView(image: UIImage(named: "profile"))
    var myNFT: [NFT] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let editImage = UIImage(named: "Edit")
        let editButton = UIBarButtonItem(
            image: editImage,
            style: .plain,
            target: self,
            action: #selector(didTapEdit)
        )
        editButton.tintColor = .black
        navigationItem.rightBarButtonItem = editButton

        profileImage.layer.cornerRadius = 35
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)

        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        nameLabel.textColor = UIColor(named: "Black")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor(named: "Black")
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)

        emailLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        emailLabel.textColor = UIColor(named: "Blue Universal")
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapEmail))
        emailLabel.addGestureRecognizer(tap)
        view.addSubview(emailLabel)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NFTCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),

            nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            emailLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            emailLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),

            tableView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 162)
        ])

        presenter = ProfilePresenter(view: self, nftCount: myNFT.count)
        presenter?.viewDidLoad()
    }

    @objc private func didTapEdit() {
        let editProfileController = EditProfileController()
        let presenter = EditProfilePresenter(
            view: editProfileController,
            name: nameLabel.text ?? "",
            description: descriptionLabel.text ?? "",
            email: emailLabel.text ?? ""
        )
        editProfileController.presenter = presenter
        editProfileController.delegate = self
        present(editProfileController, animated: true)
    }

    @objc private func didTapEmail() {
        if let url = URL(string: "https://joaquinphoenix.com") {
            UIApplication.shared.open(url)
        }
    }
}

extension ProfileViewController: EditProfileDelegate {
    func didUpdateProfile(name: String, description: String, email: String, image: UIImage?) {
        nameLabel.text = name
        descriptionLabel.text = description
        emailLabel.text = email
        profileImage.image = image
    }
}

extension ProfileViewController: ProfileProtocol {
    func setupProfile(_ profile: Profile) {
        nameLabel.text = profile.name
        emailLabel.text = profile.email
        nftCount = profile.nftCount
        profileImage.image = profile.image

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 18
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .paragraphStyle: paragraphStyle,
            .kern: -0.08
        ]
        descriptionLabel.attributedText = NSAttributedString(string: profile.description, attributes: attributes)

        tableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftCount.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NFTCell", for: indexPath)
        let (title, count) = nftCount[indexPath.row]
        let fullTitle = count != nil ? "\(title) (\(count!))" : title

        cell.textLabel?.text = fullTitle
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        cell.textLabel?.textColor = .label
        cell.selectionStyle = .none

        let arrowImage = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        let arrowImageView = UIImageView(image: arrowImage)
        arrowImageView.tintColor = UIColor(named: "Black")
        cell.accessoryView = arrowImageView

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let myNFTController = MyNFTController()
            let presenter = MyNFTPresenter(view: myNFTController)
            myNFTController.inject(presenter: presenter)
            myNFTController.delegate = self

            let back = UIBarButtonItem()
            back.title = ""
            navigationItem.backBarButtonItem = back
            navigationController?.navigationBar.tintColor = .black

            myNFTController.title = "Мои NFT"
            myNFTController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myNFTController, animated: true)

        case 1:
            let favoriteNFTController = FavoriteNFTController()
            favoriteNFTController.view.backgroundColor = .white
            favoriteNFTController.title = "Избранные NFT"
            favoriteNFTController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(favoriteNFTController, animated: true)

        case 2:
            if let url = URL(string: "https://joaquinphoenix.com") {
                UIApplication.shared.open(url)
            }

        default:
            break
        }
    }

}
