//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Артем Табенский on 07.06.2025.
//

import UIKit

final class PaymentViewController: UIViewController, PaymentViewControllerProtocol {
    
    var presenter: PaymentPresenterProtocol?
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.left")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите способ оплаты"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userAgreementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(useragreementButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.corner16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(presenter: PaymentPresenter())
        setupViews()
        setupConstraints()
        
        presenter?.viewDidLoad()
    }
    
    private func setup(presenter: PaymentPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
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
    
    func showPaymentError() {
        let alert = UIAlertController(
            title: nil,
            message: "Не удалось произвести оплату",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
            
        })
        
        present(alert, animated: true)
    }
    
    func dismissToCart() {
        dismiss(animated: true)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func useragreementButtonTapped() {
        let webVC = WebViewController()
        present(webVC, animated: true)
    }
    
    @objc private func payButtonTapped() {
        let successVC = SuccessViewController()
        successVC.modalPresentationStyle = .fullScreen
        successVC.onSuccess = onSuccess
        present(successVC, animated: true)
    }
}

#Preview(traits: .defaultLayout, body: {
    PaymentViewController()
})
