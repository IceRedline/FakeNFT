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

        let networkClient = DefaultNetworkClient()
        
        let collectionsService = DefaultCollectionsService(client: networkClient)
        let presenter = CollectionsPresenter(collectionsService: collectionsService)
        let controller = CollectionsViewController(presenter)
        let navController = UINavigationController(rootViewController: controller)
        presenter.view = controller
        controller.tabBarItem = catalogTabBarItem

        viewControllers = [navController]

        view.backgroundColor = UIColor(resource: .ypWhite)
    }
}
