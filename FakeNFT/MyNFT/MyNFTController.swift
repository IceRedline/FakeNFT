//
//  MyNFTController.swift
//  FakeNFT
//
//  Created by Anastasiia on 09.06.2025.
//

import UIKit

protocol MyNFTControllerDelegate: AnyObject {
    func myNFTController(_ controller: MyNFTController, didUpdateNFTCount count: Int)
}

private let emptyLabel: UILabel = {
    let label = UILabel()
    label.text = "У Вас ещё нет NFT"
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.isHidden = true
    return label
}()

final class MyNFTController: UIViewController {
    private let tableView = UITableView()
    private var presenter: MyNFTPresenterProtocol?
    private var nfts: [NFTModel] = []
    weak var delegate: MyNFTControllerDelegate?
    
    func inject(presenter: MyNFTPresenterProtocol) {
        self.presenter = presenter
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let presenter = presenter else {
            assertionFailure("Presenter is missing")
            return
        }
        
        view.backgroundColor = .white
        
        setupActivityIndicator()
        activityIndicator.startAnimating()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.rowHeight = 140
        tableView.separatorStyle = .none
        tableView.register(MyNFTCell.self, forCellReuseIdentifier: MyNFTCell.reuseIdentifier)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        setupActivityIndicator()
        activityIndicator.startAnimating()
        presenter.viewDidLoad()
    }
    
    @objc private func didTapSort() {
        guard let presenter = presenter else {
            assertionFailure("Presenter is missing")
            return
        }
        presenter.didTapSort()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension MyNFTController: MyNFTViewProtocol {
    func setupNFT(_ nfts: [NFTModel]) {
        self.nfts = nfts
        MyNFTStorage.shared.nfts = nfts
        tableView.reloadData()
        
        let isEmpty = nfts.isEmpty
        emptyLabel.isHidden = !isEmpty
        navigationItem.title = isEmpty ? nil : "Мои NFT"
        navigationItem.rightBarButtonItem = isEmpty ? nil : UIBarButtonItem(
            image: UIImage(named: "Sort"),
            style: .plain,
            target: self,
            action: #selector(didTapSort)
        )
        activityIndicator.stopAnimating()
        delegate?.myNFTController(self, didUpdateNFTCount: nfts.count)
    }
    
    func showSortOptions() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            self?.presenter?.sort(by: .price)
        })
        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.presenter?.sort(by: .rating)
        })
        alert.addAction(UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.presenter?.sort(by: .name)
        })
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        present(alert, animated: true)
    }
}

extension MyNFTController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nft = nfts[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTCell.reuseIdentifier, for: indexPath) as? MyNFTCell else {
            assertionFailure("Failed to get cell MyNFTCell")
            return UITableViewCell()
        }
        
        cell.configure(with: nft)
        return cell
    }
}
