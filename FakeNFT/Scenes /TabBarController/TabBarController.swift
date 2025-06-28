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
    
    private let cartTabBarItem = UITabBarItem(
        title: "Корзина",
        image: UIImage(named: "cartSelected"),
        selectedImage: UIImage(named: "cartNotSelected")
    )
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let cartController = CartViewController()
        cartController.tabBarItem = cartTabBarItem
        let profileTab = createTab(
            viewController: ProfileViewController(),
            title: NSLocalizedString("Профиль", comment: ""),
            imageName: "TabBarProfile"
        )
        viewControllers = [profileTab, catalogController, cartController]

        view.backgroundColor = .systemBackground
        UITabBar.appearance().unselectedItemTintColor = .black
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
