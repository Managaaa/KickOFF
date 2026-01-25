import UIKit

//base coordinator protocol
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
