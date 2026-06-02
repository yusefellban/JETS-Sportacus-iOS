import UIKit

class SportsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // Local array for testing UI. Presenter bindings will be added in Phase 5.
    var sports: [Sport] = Sport.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sports"
        
        // Setup background using custom asset image or fallback color
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        if let bgImage = UIImage(named: "screen_bg") {
            bgImageView.image = bgImage
        } else {
            bgImageView.backgroundColor = UIColor(named: "DeepForestNight") ?? .systemBackground
        }
        collectionView.backgroundView = bgImageView
        
        // Register cell class
        collectionView.register(SportCategoryCollectionViewCell.self, forCellWithReuseIdentifier: SportCategoryCollectionViewCell.reuseIdentifier)
        
        // Configure collection view padding
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SportCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! SportCategoryCollectionViewCell
        cell.configure(with: sports[indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let spacing: CGFloat = 16
        let totalHorizontalPadding = padding * 2 + spacing
        let availableWidth = collectionView.bounds.width - totalHorizontalPadding
        let itemWidth = availableWidth / 2
        
        // Make the height slightly taller than width for a premium look
        let itemHeight = itemWidth * 1.2
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
