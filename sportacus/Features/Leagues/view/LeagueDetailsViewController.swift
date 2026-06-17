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
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "tray.fill")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "No League Data Available"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        return view
    }()
    
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
        
        view.addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.bringSubviewToFront(activityIndicator)
        
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
        checkEmptyState()
    }
    
    private func checkEmptyState() {
        let isEmpty = upcomingEvents.isEmpty && latestEvents.isEmpty && teams.isEmpty
        emptyStateView.isHidden = !isEmpty
        scrollView.isHidden = isEmpty
    }
    
    func displayLeagueName(_ name: String) {
        title = name
    }
    
    func displayUpcomingEvents(_ events: [UpcomingEvent]) {
        self.upcomingEvents = events
        if events.isEmpty {
            setEmptyMessage("No upcoming events", for: upcomingCollectionView, iconName: "calendar")
        } else {
            clearEmptyMessage(for: upcomingCollectionView)
        }
        upcomingCollectionView.reloadData()
    }
    
    func displayLatestEvents(_ events: [LatestEvent]) {
        self.latestEvents = events
        if events.isEmpty {
            setEmptyMessage("No latest events", for: latestEventsCollectionView, iconName: "clock")
            latestEventsHeightConstraint?.constant = 140
        } else {
            clearEmptyMessage(for: latestEventsCollectionView)
            latestEventsCollectionView.reloadData()
            latestEventsCollectionView.layoutIfNeeded()
            latestEventsHeightConstraint?.constant = latestEventsCollectionView.collectionViewLayout.collectionViewContentSize.height
        }
        latestEventsCollectionView.reloadData()
        view.setNeedsLayout()
    }
    
    func displayTeams(_ teams: [Team]) {
        self.teams = teams
        if teams.isEmpty {
            setEmptyMessage("No teams available", for: teamsCollectionView, iconName: "person.3")
        } else {
            clearEmptyMessage(for: teamsCollectionView)
        }
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
    
    // MARK: - Empty State Helpers
    private func setEmptyMessage(_ message: String, for collectionView: UICollectionView, iconName: String) {
        let view = UIView()
        view.frame = collectionView.bounds
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: iconName)
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = message
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        collectionView.backgroundView = view
    }
    
    private func clearEmptyMessage(for collectionView: UICollectionView) {
        collectionView.backgroundView = nil
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
