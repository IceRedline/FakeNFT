import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        configureNavigationBarAppearance()
        configureTabBarAppearance()
        
//        let tabBarController = TabBarController(servicesAssembly: servicesAssembly)
        let viewController = CollectionDetailViewController()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = /*tabBarController*/ UINavigationController(rootViewController: viewController)
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(resource: .ypWhite)
        UINavigationBar.appearance().tintColor = UIColor(resource: .ypBlack)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(resource: .ypWhite)
        appearance.shadowColor = .clear

        UITabBar.appearance().tintColor = UIColor(resource: .ypBlue)
        UITabBar.appearance().unselectedItemTintColor = UIColor(resource: .ypBlack)
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
}
