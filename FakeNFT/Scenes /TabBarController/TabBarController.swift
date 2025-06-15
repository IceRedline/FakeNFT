import UIKit

final class TabBarController: UITabBarController {
    
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogPresenter = CatalogPresenter()
        let catalogController = CatalogViewController(catalogPresenter)
        let navController = UINavigationController(rootViewController: catalogController)
        catalogPresenter.view = catalogController
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [navController]

        view.backgroundColor = UIColor(resource: .ypWhite)
    }
}
