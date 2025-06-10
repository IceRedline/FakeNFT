//
//  MyNFTController.swift
//  FakeNFT
//
//  Created by Anastasiia on 09.06.2025.
//

import UIKit

final class MyNFTController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Sort"),
            style: .plain,
            target: self,
            action: #selector(didTapSort)
        )
    }

    @objc func didTapSort() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "По цене", style: .default) { _ in
            print("Сортировка по цене")
        })

        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
            print("Сортировка по рейтингу")
        })

        alert.addAction(UIAlertAction(title: "По названию", style: .default) { _ in
            print("Сортировка по названию")
        })

        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))

        present(alert, animated: true)
    }
}
