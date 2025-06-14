import UIKit

protocol CatalogView: AnyObject, LoadingView, ErrorView {
    func showCells(_ cellModels: [CollectionCellViewModel])
}

final class CatalogViewController: UITableViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let topInset: CGFloat = 20
        static let rowHeight: CGFloat = 179
        static let rowSpacing: CGFloat = 8
    }
    
    // MARK: - Internal Properties
    
    lazy var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Private Properties
    
    private var presenter: CatalogPresenterProtocol
    private var cellModels: [CollectionCellViewModel] = []
    
    // MARK: - Init

    init(_ presenter: CatalogPresenterProtocol) {
        self.presenter = presenter
        super.init(style: .plain)
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

// MARK: - CatalogView

extension CatalogViewController: CatalogView {
    
    func showCells(_ cellModels: [CollectionCellViewModel]) {
        self.cellModels = cellModels
        tableView.reloadData()
    }
    
}

// MARK: - Private Methods

private extension CatalogViewController {
    
    func setupViewController() {
        view.backgroundColor = UIColor(resource: .ypWhite)
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
        tableView.register(CollectionCell.self, forCellReuseIdentifier: CollectionCell.reuseIdentifier)
    }
    
}

// MARK: - Actions

@objc
private extension CatalogViewController {
    
    func sortButtonDidTap() {
        
    }
    
}

// MARK: - Data Source

extension CatalogViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionCell.reuseIdentifier,
                for: indexPath
            ) as? CollectionCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: cellModels[indexPath.row])
        return cell
    }
    
}

// MARK: - Delegate

extension CatalogViewController {
    
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
