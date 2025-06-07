//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Артем Табенский on 07.06.2025.
//

import UIKit

class PaymentViewController: UIViewController, PaymentViewControllerProtocol {
    
    var presenter: PaymentPresenterProtocol?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.left")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите способ оплаты"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let userAgreementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(UIColor(named: "ypWhite"), for: .normal)
        button.backgroundColor = UIColor(named: "ypBlack")
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(presenter: PaymentPresenter())
        setupViews()
        setupConstraints()
    }
    
    private func setup(presenter: PaymentPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "ypWhite")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        
        collectionView.register(PaymentCollectionViewCell.self, forCellWithReuseIdentifier: "PaymentCollectionViewCell")
        collectionView.dataSource = presenter
        collectionView.delegate = presenter
        
        [backButton, titleLabel, collectionView, bottomView].forEach { view.addSubview($0) }
        [textLabel, userAgreementButton, payButton].forEach { bottomView.addSubview($0) }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            collectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),

            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 186),

            textLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 18),
            textLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),

            userAgreementButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 4),
            userAgreementButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),

            payButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}

#Preview(traits: .defaultLayout, body: {
    PaymentViewController()
})
