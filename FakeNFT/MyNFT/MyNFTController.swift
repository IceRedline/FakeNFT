//
//  MyNFTController.swift
//  FakeNFT
//
//  Created by Anastasiia on 09.06.2025.
//

//import UIKit
//
//final class MyNFTController: UIViewController {
//
//    var nfts: [NFT] = [
//        NFT(imageName: "NFT", name: "Lilo", rating: 3, creator: "John Doe", price: 1.78)
//    ]
//    var onNFTsUpdated: ((Int) -> Void)?
//    
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.rowHeight = 140
//        tableView.separatorStyle = .none
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(MyNFTCell.self, forCellReuseIdentifier: MyNFTCell.reuseIdentifier)
//        return tableView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//                navigationItem.rightBarButtonItem = UIBarButtonItem(
//                    image: UIImage(named: "Sort"),
//                    style: .plain,
//                    target: self,
//                    action: #selector(didTapSort)
//                )
//
//        setupTableView()
//        onNFTsUpdated?(nfts.count)
//
//    }
//
//    private func setupTableView() {
//        view.addSubview(tableView)
//        tableView.dataSource = self
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//    }
//
//
//    @objc func didTapSort() {
//        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
//
//        alert.addAction(UIAlertAction(title: "По цене", style: .default) { _ in
//            print("Сортировка по цене")
//        })
//        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
//            print("Сортировка по рейтингу")
//        })
//        alert.addAction(UIAlertAction(title: "По названию", style: .default) { _ in
//            print("Сортировка по названию")
//        })
//        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
//
//        present(alert, animated: true)
//    }
//}
//
//extension MyNFTController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        nfts.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let nft = nfts[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTCell.reuseIdentifier, for: indexPath) as! MyNFTCell
//        cell.configure(with: nft)
//        return cell
//    }
//}
//
//
//import UIKit
//
//final class MyNFTCell: UITableViewCell {
//    static let reuseIdentifier = "MyNFTCell"
//    
//    private let nftImage = UIImageView()
//    private let nameLabel = UILabel()
//    private let creatorPrefixLabel = UILabel()
//    private let creatorNameLabel = UILabel()
//    private let stars = UIStackView()
//    private let priceLabel = UILabel()
//    private let priceValueLabel = UILabel()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        nftImage.translatesAutoresizingMaskIntoConstraints = false
//        nftImage.layer.cornerRadius = 12
//        nftImage.clipsToBounds = true
//        nftImage.contentMode = .scaleAspectFill
//        contentView.addSubview(nftImage)
//
//        NSLayoutConstraint.activate([
//            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            nftImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            nftImage.widthAnchor.constraint(equalToConstant: 108),
//            nftImage.heightAnchor.constraint(equalToConstant: 108)
//        ])
//                                
//        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        nameLabel.textColor = UIColor(named: "Black")
//
//        creatorPrefixLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
//        creatorPrefixLabel.textColor = UIColor(named: "Black")
//        
//        creatorNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
//        creatorNameLabel.textColor = UIColor(named: "Black")
//
//        let creatorStack = UIStackView(arrangedSubviews: [creatorPrefixLabel, creatorNameLabel])
//        creatorStack.axis = .horizontal
//        creatorStack.spacing = 4
//
//        stars.axis = .horizontal
//        stars.spacing = 2
//        stars.translatesAutoresizingMaskIntoConstraints = false
//
//        priceLabel.text = "Цена"
//        priceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
//        priceLabel.textColor = UIColor(named: "Black")
//
//        priceValueLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        priceValueLabel.textColor = UIColor(named: "Black")
//
//        let textStack = UIStackView(arrangedSubviews: [nameLabel, stars, creatorStack])
//        textStack.axis = .vertical
//        textStack.spacing = 4
//        textStack.translatesAutoresizingMaskIntoConstraints = false
//
//        let priceStack = UIStackView(arrangedSubviews: [priceLabel, priceValueLabel])
//        priceStack.axis = .vertical
//        priceStack.alignment = .leading
//        priceStack.spacing = 4
//        priceStack.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.addSubview(textStack)
//        contentView.addSubview(priceStack)
//
//        NSLayoutConstraint.activate([
//            textStack.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 16),
//            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            textStack.trailingAnchor.constraint(lessThanOrEqualTo: priceStack.leadingAnchor, constant: -12),
//            
//            priceStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            priceStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func configure(with nft: NFT) {
//        nftImage.image = UIImage(named: nft.imageName)
//        nameLabel.text = nft.name
//        creatorPrefixLabel.text = "от"
//        creatorNameLabel.text = nft.creator
//        priceValueLabel.text = String(format: "%.2f ETH", nft.price)
//        updateStars(rating: nft.rating)
//    }
//
//    private func updateStars(rating: Int) {
//        stars.arrangedSubviews.forEach { $0.removeFromSuperview() }
//        
//        for i in 1...5 {
//            let starImage = UIImage(systemName: i <= rating ? "star.fill" : "star")
//            let imageView = UIImageView(image: starImage)
//            imageView.tintColor = .systemYellow
//            imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
//            imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
//            stars.addArrangedSubview(imageView)
//        }
//    }
//}



import UIKit

protocol MyNFTControllerDelegate: AnyObject {
    func myNFTController(_ controller: MyNFTController, didUpdateNFTCount count: Int)
}

final class MyNFTController: UIViewController {
    private let tableView = UITableView()
    private var presenter: MyNFTPresenterProtocol!
    private var nfts: [NFT] = []
    weak var delegate: MyNFTControllerDelegate?

    func inject(presenter: MyNFTPresenterProtocol) {
        self.presenter = presenter
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @objc func didTapSort() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTCell.reuseIdentifier, for: indexPath) as! MyNFTCell
        cell.configure(with: nft)
        return cell
    }
}
