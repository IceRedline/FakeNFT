final class ServicesAssembly {
    
    var stateService: StateService

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.stateService = DefaultStateService(networkClient: networkClient)
    }
    
    var collectionService: NftCollectionService {
        DefaultNftCollectionService(networkClient: networkClient)
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
}
