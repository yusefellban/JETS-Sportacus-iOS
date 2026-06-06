import UIKit

class LeagueDetailsViewController: UIViewController, LeagueDetailsViewProtocol, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var presenter: LeagueDetailsPresenterProtocol?
    
    private var upcomingEvents: [UpcomingEvent] = []
    private var latestEvents: [LatestEvent] = []
    private var teams: [Team] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    // Section 1: Upcoming Events
    @IBOutlet weak var upcomingHeaderLabel: UILabel!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    
    // Section 2: Latest Events
    @IBOutlet weak var latestHeaderLabel: UILabel!
    @IBOutlet weak var latestEventsCollectionView: UICollectionView!
    @IBOutlet weak var latestEventsHeightConstraint: NSLayoutConstraint!
    
    // Section 3: Teams
    @IBOutlet weak var teamsHeaderLabel: UILabel!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register programmatic cell classes (cells are not XIB-based)
        upcomingCollectionView.register(UpcomingEventCollectionViewCell.self, forCellWithReuseIdentifier: UpcomingEventCollectionViewCell.reuseIdentifier)
        latestEventsCollectionView.register(LatestEventCollectionViewCell.self, forCellWithReuseIdentifier: LatestEventCollectionViewCell.reuseIdentifier)
        teamsCollectionView.register(TeamCollectionViewCell.self, forCellWithReuseIdentifier: TeamCollectionViewCell.reuseIdentifier)
        
        // Apply LimeNeon tint — CALayer colors cannot reference named colors in storyboard
        activityIndicator.color = UIColor(named: "LimeNeon") ?? .systemGreen
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Dynamically adjust latestEventsCollectionView height constraint to its content size
        latestEventsCollectionView.layoutIfNeeded()
        latestEventsHeightConstraint?.constant = latestEventsCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    // MARK: - Action Selectors
    @objc private func favoriteButtonTapped() {
        guard let isFav = presenter?.isFavorite else {
            presenter?.toggleFavorite()
            return
        }
        
        if isFav {
            let alert = UIAlertController(
                title: "Remove from Favorites",
                message: "Are you sure you want to remove this league from your favorites?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
                self?.presenter?.toggleFavorite()
            })
            present(alert, animated: true)
        } else {
            presenter?.toggleFavorite()
        }
    }
    
    // MARK: - LeagueDetailsViewProtocol
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func displayLeagueName(_ name: String) {
        title = name
    }
    
    func displayUpcomingEvents(_ events: [UpcomingEvent]) {
        self.upcomingEvents = events
        upcomingCollectionView.reloadData()
    }
    
    func displayLatestEvents(_ events: [LatestEvent]) {
        self.latestEvents = events
        latestEventsCollectionView.reloadData()
        latestEventsCollectionView.layoutIfNeeded()
        latestEventsHeightConstraint?.constant = latestEventsCollectionView.collectionViewLayout.collectionViewContentSize.height
        view.setNeedsLayout()
    }
    
    func displayTeams(_ teams: [Team]) {
        self.teams = teams
        teamsCollectionView.reloadData()
    }
    
    func showFavoriteState(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let favoriteImage = UIImage(systemName: imageName)
        
        let favoriteButton = UIBarButtonItem(
            image: favoriteImage,
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        favoriteButton.tintColor = UIColor(named: "LimeNeon") ?? .systemGreen
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == upcomingCollectionView {
            return upcomingEvents.count
        } else if collectionView == latestEventsCollectionView {
            return latestEvents.count
        } else if collectionView == teamsCollectionView {
            return teams.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == upcomingCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingEventCollectionViewCell.reuseIdentifier, for: indexPath) as! UpcomingEventCollectionViewCell
            cell.configure(with: upcomingEvents[indexPath.item])
            return cell
        } else if collectionView == latestEventsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LatestEventCollectionViewCell.reuseIdentifier, for: indexPath) as! LatestEventCollectionViewCell
            cell.configure(with: latestEvents[indexPath.item])
            return cell
        } else if collectionView == teamsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamCollectionViewCell.reuseIdentifier, for: indexPath) as! TeamCollectionViewCell
            cell.configure(with: teams[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout & UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        if collectionView == upcomingCollectionView {
            // Horizontal card: 75% of screen width
            return CGSize(width: width * 0.75, height: 140)
        } else if collectionView == latestEventsCollectionView {
            // Vertical card: full width
            return CGSize(width: width, height: 86)
        } else if collectionView == teamsCollectionView {
            // Horizontal circular team card
            return CGSize(width: 80, height: 100)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == teamsCollectionView {
            let selectedTeam = teams[indexPath.item]
            presenter?.selectTeam(at: indexPath.item)
            
            // Instantiate TeamDetailsViewController from storyboard (no XIB)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let teamDetailsVC = storyboard.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? TeamDetailsViewController {
                teamDetailsVC.configure(with: selectedTeam)
                navigationController?.pushViewController(teamDetailsVC, animated: true)
            }
        }
    }
}
