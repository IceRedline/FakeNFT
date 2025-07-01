import UIKit

protocol NftCollectionsView: AnyObject, LoadingView, ErrorView {
    func displayCells(_ cellModels: [NftCollectionCellViewModel])
    func navigateToCollectionDetail(with input: NftCollectionDetailInput, servicesAssembly: ServicesAssembly)
}

final class NftCollectionsViewController: UITableViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let topInset: CGFloat = 20
        static let rowHeight: CGFloat = 179
        static let rowSpacing: CGFloat = 8
    }
    
    // MARK: - Subviews
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .gray
        return activityIndicator
    }()
    
    // MARK: - Private Properties
    
    private var presenter: NftCollectionsPresenterProtocol
    private var cellModels: [NftCollectionCellViewModel] = []
    
    // MARK: - Init

    init(_ presenter: NftCollectionsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        setupTableView()
        presenter.viewDidLoad()
    }

}

// MARK: - CollectionsView

extension NftCollectionsViewController: NftCollectionsView {
    
    func displayCells(_ cellModels: [NftCollectionCellViewModel]) {
        self.cellModels = cellModels
        tableView.reloadData()
    }
    
    func navigateToCollectionDetail(with input: NftCollectionDetailInput, servicesAssembly: ServicesAssembly) {
        let detailPresenter = NftCollectionDetailPresenter(servicesAssembly: servicesAssembly, input: input)
        let detailViewController = NftCollectionDetailViewController(detailPresenter)
        detailPresenter.view = detailViewController
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

// MARK: - Private Methods

private extension NftCollectionsViewController {
    
    func setupViewController() {
        view.backgroundColor = UIColor(resource: .ypWhite)
        tableView.backgroundView = activityIndicator
    }
    
    func setupNavigationBar() {
        let sortButton = UIBarButtonItem(
            image: UIImage(resource: .sort),
            style: .plain,
            target: self,
            action: #selector(sortButtonDidTap)
        )
        navigationItem.rightBarButtonItem = sortButton
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset.top = Constants.topInset
        tableView.register(NftCollectionCell.self, forCellReuseIdentifier: NftCollectionCell.reuseIdentifier)
    }
    
}

// MARK: - Actions

@objc
private extension NftCollectionsViewController {
    
    func sortButtonDidTap() {
        let alert = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.presenter.sortCollectionsByName()
        })
        alert.addAction(UIAlertAction(title: "По количеству NFT", style: .default) { [weak self] _ in
            self?.presenter.sortCollectionsByNFTCount()
        })
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        present(alert, animated: true)
    }
    
}

// MARK: - Data Source

extension NftCollectionsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NftCollectionCell.reuseIdentifier,
                for: indexPath
            ) as? NftCollectionCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: cellModels[indexPath.row])
        return cell
    }
    
}

// MARK: - Delegate

extension NftCollectionsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectCollection(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        Constants.rowSpacing
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
    }
    
}
