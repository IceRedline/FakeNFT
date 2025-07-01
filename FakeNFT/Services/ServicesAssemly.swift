final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
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
