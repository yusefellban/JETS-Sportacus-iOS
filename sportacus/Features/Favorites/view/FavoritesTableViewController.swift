import UIKit

class FavoritesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "DeepForestNight") ?? .systemBackground
        title = "Favorites"
    }
}
