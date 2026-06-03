import UIKit

class LeagueDetailsViewController: UIViewController, LeagueDetailsViewProtocol, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var presenter: LeagueDetailsPresenterProtocol?
    
    private var upcomingEvents: [UpcomingEvent] = []
    private var latestEvents: [LatestEvent] = []
    private var teams: [Team] = []
    
    // Constraints
    private var latestEventsHeightConstraint: NSLayoutConstraint?
    
    // UI Elements
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(named: "LimeNeon") ?? .systemGreen
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 24
        sv.alignment = .fill
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: - Section 1: Upcoming Events UI
    private let upcomingHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Upcoming Events"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var upcomingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(UpcomingEventCollectionViewCell.self, forCellWithReuseIdentifier: UpcomingEventCollectionViewCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - Section 2: Latest Events UI
    private let latestHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Latest Events"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var latestEventsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false // Let the parent scroll view handle scrolling
        cv.dataSource = self
        cv.delegate = self
        cv.register(LatestEventCollectionViewCell.self, forCellWithReuseIdentifier: LatestEventCollectionViewCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - Section 3: Teams UI
    private let teamsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Teams"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var teamsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(TeamCollectionViewCell.self, forCellWithReuseIdentifier: TeamCollectionViewCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 250/255, alpha: 1.0)
        
        setupViews()
        setupLoadingIndicator()
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Dynamically adjust latestEventsCollectionView height constraint to its content size
        latestEventsCollectionView.layoutIfNeeded()
        latestEventsHeightConstraint?.constant = latestEventsCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    // MARK: - Setup UI Layout
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        // Setup ScrollView and ContentView constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Add Section 1: Upcoming Events
        let upcomingSection = UIStackView()
        upcomingSection.axis = .vertical
        upcomingSection.spacing = 10
        upcomingSection.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        upcomingSection.isLayoutMarginsRelativeArrangement = true
        upcomingSection.addArrangedSubview(upcomingHeaderLabel)
        upcomingSection.addArrangedSubview(upcomingCollectionView)
        stackView.addArrangedSubview(upcomingSection)
        
        // Add Section 2: Latest Events
        let latestSection = UIStackView()
        latestSection.axis = .vertical
        latestSection.spacing = 10
        latestSection.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) // Full width for vertical cells
        latestSection.isLayoutMarginsRelativeArrangement = true
        
        // Header needs horizontal margins
        let latestHeaderContainer = UIView()
        latestHeaderContainer.translatesAutoresizingMaskIntoConstraints = false
        latestHeaderContainer.addSubview(latestHeaderLabel)
        NSLayoutConstraint.activate([
            latestHeaderLabel.topAnchor.constraint(equalTo: latestHeaderContainer.topAnchor),
            latestHeaderLabel.bottomAnchor.constraint(equalTo: latestHeaderContainer.bottomAnchor),
            latestHeaderLabel.leadingAnchor.constraint(equalTo: latestHeaderContainer.leadingAnchor, constant: 16),
            latestHeaderLabel.trailingAnchor.constraint(equalTo: latestHeaderContainer.trailingAnchor, constant: -16)
        ])
        latestSection.addArrangedSubview(latestHeaderContainer)
        latestSection.addArrangedSubview(latestEventsCollectionView)
        stackView.addArrangedSubview(latestSection)
        
        // Add Section 3: Teams
        let teamsSection = UIStackView()
        teamsSection.axis = .vertical
        teamsSection.spacing = 10
        teamsSection.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 20, right: 16)
        teamsSection.isLayoutMarginsRelativeArrangement = true
        teamsSection.addArrangedSubview(teamsHeaderLabel)
        teamsSection.addArrangedSubview(teamsCollectionView)
        stackView.addArrangedSubview(teamsSection)
        
        // Constraints inside StackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Heights for horizontal scrolling collections
            upcomingCollectionView.heightAnchor.constraint(equalToConstant: 146),
            teamsCollectionView.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        // Height constraint for the vertical collection view (Latest Events)
        latestEventsHeightConstraint = latestEventsCollectionView.heightAnchor.constraint(equalToConstant: 200)
        latestEventsHeightConstraint?.isActive = true
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Action Selectors
    @objc private func favoriteButtonTapped() {
        presenter?.toggleFavorite()
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
            // Vertical card: Full width minus section margins (16 * 2 = 32)
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
            
            // Direct to the team details
            let teamDetailsVC = TeamDetailsViewController(team: selectedTeam)
            navigationController?.pushViewController(teamDetailsVC, animated: true)
        }
    }
}
