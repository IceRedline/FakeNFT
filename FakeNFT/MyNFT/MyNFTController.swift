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

final class MyNFTController: UIViewController {
    private let tableView = UITableView()
    private var presenter: MyNFTPresenterProtocol?
    private var nfts: [NFT] = []
    weak var delegate: MyNFTControllerDelegate?
    
    func inject(presenter: MyNFTPresenterProtocol) {
        self.presenter = presenter
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let presenter = presenter else {
            assertionFailure("Presenter is missing")
            return
        }
        presenter.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Sort"),
            style: .plain,
            target: self,
            action: #selector(didTapSort)
        )
        
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
    }
    
    @objc private func didTapSort() {
        
        guard let presenter = presenter else {
            assertionFailure("Presenter is missing")
            return
        }
        presenter.didTapSort()
    }
}

extension MyNFTController: MyNFTViewProtocol {
    func setupNFT(_ nfts: [NFT]) {
        self.nfts = nfts
        tableView.reloadData()
        
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
