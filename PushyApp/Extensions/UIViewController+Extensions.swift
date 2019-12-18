import UIKit

extension UIViewController {
    /// Instantiates Viewcontroller from xib file
    ///
    /// - Returns: The instantiated controller with all its UI elements loaded
    static func loadFromXib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
    
    func showSimpleAlert(title: String, message: String, buttonActionTitle: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: buttonActionTitle, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
