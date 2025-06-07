//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Артем Табенский on 06.06.2025.
//

import UIKit

final class CartViewController: UIViewController, CartViewControllerProtocol {
    
    var presenter: CartPresenterProtocol?
    
    let tableView = UITableView()
    
    let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sortButtonImage"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ypLightGray")
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nftCountLabel: UILabel = {
        let label = UILabel()
        label.text = "3 NFT"
        label.textColor = UIColor(named: "ypBlack")
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nftTotalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "5,34 ETH"
        label.textColor = UIColor(named: "ypGreen")
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let payButton: UIButton = {
        let button = UIButton()
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor(named: "ypBlack")
        button.titleLabel?.textColor = UIColor(named: "ypWhite")
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(presenter: CartPresenter())
        setupViews()
        setupConstraints()
    }
    
    private func setup(presenter: CartPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    private func setupViews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
        tableView.delegate = presenter
        tableView.dataSource = presenter
        
        view.addSubview(sortButton)
        view.addSubview(bottomView)
        bottomView.addSubview(nftCountLabel)
        bottomView.addSubview(nftTotalPriceLabel)
        bottomView.addSubview(payButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 76),
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            nftCountLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            nftCountLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            nftTotalPriceLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            nftTotalPriceLabel.topAnchor.constraint(equalTo: nftCountLabel.bottomAnchor, constant: 2),
            payButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            payButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            payButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            payButton.leadingAnchor.constraint(equalTo: nftTotalPriceLabel.trailingAnchor, constant: 16)
        ])
    }
    
    @objc private func payButtonTapped() {
        let vc = PaymentViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}

#Preview(body: {
    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    let tabBar = TabBarController(servicesAssembly: servicesAssembly)
    tabBar.selectedIndex = 1
    return tabBar
})
