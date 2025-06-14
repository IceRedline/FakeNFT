//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Артем Табенский on 11.06.2025.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    var webView = WKWebView()
    var loadingProgressBar = UIProgressView()
    
    private lazy var backButton: UIButton = {
        var button = UIButton()
        button.setTitle("< Вернуться", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        fetchURLRequest()
    }
    
    // MARK: - UI
    
    private func setupViews() {
        view.backgroundColor = .white
        [webView, loadingProgressBar, backButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            loadingProgressBar.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            webView.topAnchor.constraint(equalTo: loadingProgressBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    

    // MARK: - ProgressBar Methods
    
    override func viewWillAppear(_ animated: Bool) {
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        loadingProgressBar.progress = Float(webView.estimatedProgress)
        loadingProgressBar.isHidden = fabs(webView.estimatedProgress - 1) <= Constants.progressBarMinimumDifference
    }
    
    // MARK: - URL Methods
    
    private func fetchURLRequest() {
        guard let url = URL(string:"https://yandex.ru/legal/practicum_termsofuse/") else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#Preview(traits: .defaultLayout, body: {
    WebViewController()
})
