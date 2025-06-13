//
//  DeleteViewController.swift
//  FakeNFT
//
//  Created by Артем Табенский on 11.06.2025.
//

import UIKit

final class DeleteViewController: UIViewController {
    
    var onDeleteConfirmed: (() -> Void)?
    
    let nftImage: UIImage
    
    let nftImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    let questionLabel: UILabel = {
        var label = UILabel()
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.corner12
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.addTarget(self, action: #selector(deleteConfirmationTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var returnButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.corner12
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let hStackView = UIStackView()
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    init(nftImage: UIImage) {
        self.nftImage = nftImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlur()
        setupHStackView()
        setupContent()
    }
    
    // MARK: - Methods
    
    private func setupBlur() {
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    private func setupHStackView() {
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.spacing = 8
        view.addSubview(hStackView)
    }
    
    private func setupContent() {
        [nftImageView, questionLabel, deleteButton, returnButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        nftImageView.image = nftImage
        
        self.view.addSubview(nftImageView)
        self.view.addSubview(questionLabel)
        
        hStackView.addArrangedSubview(deleteButton)
        hStackView.addArrangedSubview(returnButton)
        
        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            
            questionLabel.widthAnchor.constraint(equalToConstant: 180),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 20),
            
            hStackView.widthAnchor.constraint(equalToConstant: 262),
            hStackView.heightAnchor.constraint(equalToConstant: 44),
            hStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            hStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func deleteConfirmationTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onDeleteConfirmed?()
        }
    }
    
    @objc private func returnButtonTapped() {
        dismiss(animated: true)
    }
    
}
