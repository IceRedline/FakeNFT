import ProgressHUD
import UIKit

protocol LoadingView {
    var activityIndicator: UIActivityIndicatorView { get }
    func showLoading()
    func hideLoading()
}

extension LoadingView where Self: UIViewController {
    
    func showLoading() {
        if activityIndicator.superview == nil {
            view.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        
        view.subviews.forEach { subview in
            if subview != activityIndicator {
                subview.isHidden = true
            }
        }
        
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        view.subviews.forEach { subview in
            if subview != activityIndicator {
                subview.isHidden = false
            }
        }
    }
}
