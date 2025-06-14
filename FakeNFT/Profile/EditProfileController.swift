//
//  EditProfileController.swift
//  FakeNFT
//
//  Created by Anastasiia on 09.06.2025.
//

import UIKit

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile(name: String, description: String, email: String, image: UIImage?)
}

final class EditProfileController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    weak var delegate: EditProfileDelegate?
    var presenter: EditProfilePresenter?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let nameField = UITextField()
    private let descriptionField = UITextView()
    private let emailField = UITextField()
    var newProfileImage: UIImage?
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let loadingOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .profile)
        image.layer.cornerRadius = 35
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let clearDescriptionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = UIColor.systemGray.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        contentView.addGestureRecognizer(tapGesture)
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.tintColor = UIColor(named: "Black")
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        let profileImageView = UIView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        profileImageView.addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            profileImage.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            profileImage.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            profileImage.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor)
        ])
        
        let changePhotoButton = UIButton(type: .system)
        changePhotoButton.setTitle("Сменить\nфото", for: .normal)
        changePhotoButton.setTitleColor(.white, for: .normal)
        changePhotoButton.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        changePhotoButton.titleLabel?.numberOfLines = 2
        changePhotoButton.titleLabel?.textAlignment = .center
        changePhotoButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        changePhotoButton.layer.cornerRadius = 35
        changePhotoButton.clipsToBounds = true
        changePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.addSubview(changePhotoButton)
        changePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            changePhotoButton.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            changePhotoButton.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            changePhotoButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            changePhotoButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor)
        ])
        
        let nameLabel = UILabel()
        nameLabel.text = "Имя"
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.textColor = UIColor(named: "Black")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        
        nameField.placeholder = ""
        nameField.backgroundColor = UIColor(resource: .lightGrey)
        nameField.layer.cornerRadius = 12
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        nameField.leftViewMode = .always
        nameField.clearButtonMode = .whileEditing
        nameField.delegate = self
        nameField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameField)
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Описание"
        descriptionLabel.font = .systemFont(ofSize: 22, weight: .bold)
        descriptionLabel.textColor = UIColor(named: "Black")
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        
        descriptionField.delegate = self
        descriptionField.backgroundColor = UIColor(resource: .lightGrey)
        descriptionField.layer.cornerRadius = 12
        descriptionField.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 40)
        descriptionField.font = .systemFont(ofSize: 16)
        descriptionField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionField)
        
        NSLayoutConstraint.activate([
            descriptionField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionField.heightAnchor.constraint(equalToConstant: 132)
        ])
        
        contentView.addSubview(clearDescriptionButton)
        clearDescriptionButton.addTarget(self, action: #selector(clearDescriptionTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            clearDescriptionButton.topAnchor.constraint(equalTo: descriptionField.topAnchor, constant: 8),
            clearDescriptionButton.trailingAnchor.constraint(equalTo: descriptionField.trailingAnchor, constant: -8),
            clearDescriptionButton.widthAnchor.constraint(equalToConstant: 20),
            clearDescriptionButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let emailLabel = UILabel()
        emailLabel.text = "Сайт"
        emailLabel.font = .systemFont(ofSize: 22, weight: .bold)
        emailLabel.textColor = UIColor(named: "Black")
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: 24),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        
        emailField.placeholder = "Введите сайт"
        emailField.backgroundColor = UIColor(resource: .lightGrey)
        emailField.layer.cornerRadius = 12
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        emailField.leftViewMode = .always
        emailField.clearButtonMode = .whileEditing
        emailField.delegate = self
        emailField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailField)
        
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emailField.heightAnchor.constraint(equalToConstant: 44),
            emailField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        setupKeyboardObservers()
        setupLoadingOverlay()
        presenter?.viewDidLoad()
    }
    
    private func setupLoadingOverlay() {
        view.addSubview(loadingOverlay)
        loadingOverlay.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
        ])
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = keyboardFrame.height + 20
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height + 20
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func closeTapped() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.presenter?.saveTapped(
                name: self.nameField.text ?? "",
                description: self.descriptionField.text ?? "",
                email: self.emailField.text ?? ""
            )
            self.activityIndicator.stopAnimating()
        }
    }
    
    @objc private func clearDescriptionTapped() {
        descriptionField.text = ""
        clearDescriptionButton.isHidden = true
        descriptionField.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        clearDescriptionButton.isHidden = textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        clearDescriptionButton.isHidden = textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        clearDescriptionButton.isHidden = true
    }
    
    @objc private func changePhotoTapped() {
        presenter?.changePhotoTapped()
    }
}

extension EditProfileController: EditProfileViewProtocol {
    func changeImage(completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "Сменить фото", message: "Введите ссылку на изображение", preferredStyle: .alert)
            alert.addTextField {
                $0.placeholder = "Ссылка"
                $0.keyboardType = .URL
                $0.autocapitalizationType = .none
            }

            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in
                completion(nil)
            })
            alert.addAction(UIAlertAction(title: "Ок", style: .default) { [weak alert] _ in
                let urlString = alert?.textFields?.first?.text
                completion(urlString)
            })

            present(alert, animated: true)
        }
    
    func showError() {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить изображение", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ок", style: .default))
           present(alert, animated: true)
    }
    
    func setProfileImage(_ image: UIImage) {
        profileImage.image = image
        newProfileImage = image
    }
    
    func showInitialData(name: String, description: String, email: String) {
        nameField.text = name
        descriptionField.text = description
        emailField.text = email
        clearDescriptionButton.isHidden = true
    }

    func closeWithResult(name: String, description: String, email: String) {
        delegate?.didUpdateProfile(
            name: name,
            description: description,
            email: email,
            image: newProfileImage ?? profileImage.image
        )
        dismiss(animated: true)
    }
}
