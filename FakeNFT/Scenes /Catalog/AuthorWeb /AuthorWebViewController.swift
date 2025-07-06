//
//  AuthorWebViewController.swift
//  FakeNFT
//
//  Created by Danil Otmakhov on 27.06.2025.
//

import UIKit
import WebKit

protocol AuthorWebView: AnyObject {
    func load(for request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class AuthorWebViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = UIColor(resource: .ypWhite)
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor(resource: .ypBlack)
        progressView.progress = 0
        return progressView
    }()
    
    // MARK: - Private Properties
    
    private let presenter: AuthorWebPresenterProtocol
    private var progressObservation: NSKeyValueObservation?
    
    // MARK: - Init

    init(presenter: AuthorWebPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        setupProgressObservation()
        presenter.viewDidLoad()
    }
    
}

extension AuthorWebViewController: AuthorWebView {
    
    func load(for request: URLRequest) {
        webView.load(request)
    }

    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
}

// MARK: - Private Methods

private extension AuthorWebViewController {
    
    func setupViewController() {
        view.backgroundColor = UIColor(resource: .ypWhite)
        
        [progressView, webView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        }
        
        let backButton = UIBarButtonItem(
            image: UIImage(resource: .backward),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setupProgressObservation() {
        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] _, change in
            guard let newValue = change.newValue else { return }
            self?.presenter.didUpdateProgressValue(newValue)
        }
    }
    
}

// MARK: - Actions

@objc
private extension AuthorWebViewController {
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
}

