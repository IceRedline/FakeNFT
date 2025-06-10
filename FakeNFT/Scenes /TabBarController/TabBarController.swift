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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().unselectedItemTintColor = .black
    }

    private func setupTabs() {
        let profileTab = createTab(
            viewController: ProfileViewController(),
            title: NSLocalizedString("Профиль", comment: ""),
            imageName: "TabBarProfile"
        )

        let catalogTab = createTab(
            viewController: TestCatalogViewController(servicesAssembly: servicesAssembly),
            title: NSLocalizedString("Каталог", comment: ""),
            imageName: "Catalog"
        )

        let cartTab = createTab(
            viewController: TestCatalogViewController(servicesAssembly: servicesAssembly),
            title: NSLocalizedString("Корзина", comment: ""),
            imageName: "Cart"
        )
        let statisticTab = createTab(
            viewController: TestCatalogViewController(servicesAssembly: servicesAssembly),
            title: NSLocalizedString("Статистика", comment: ""),
            imageName: "Statistics"
        )

        viewControllers = [profileTab, catalogTab, cartTab, statisticTab]
    }

    private func createTab(viewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: imageName),
            selectedImage: nil
        )
        return navController
    }
}
