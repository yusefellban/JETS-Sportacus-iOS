import UIKit

class LatestEventCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "LatestEventCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.04
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 6
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Home Team UI
    private let homeLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = UIColor.systemGray6
        iv.tintColor = UIColor(named: "LimeNeon") ?? .systemGreen
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let homeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Score Capsule UI
    private let scoreContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "DeepForestNight") ?? .black
        view.layer.cornerRadius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "LimeNeon") ?? .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Away Team UI
    private let awayLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = UIColor.systemGray6
        iv.tintColor = UIColor(named: "LimeNeon") ?? .systemGreen
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let awayNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Date & Time UI
    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(homeLogoImageView)
        containerView.addSubview(homeNameLabel)
        containerView.addSubview(scoreContainer)
        scoreContainer.addSubview(scoreLabel)
        containerView.addSubview(awayNameLabel)
        containerView.addSubview(awayLogoImageView)
        containerView.addSubview(dateTimeLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Score Capsule in the center
            scoreContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            scoreContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -8),
            scoreContainer.widthAnchor.constraint(equalToConstant: 64),
            scoreContainer.heightAnchor.constraint(equalToConstant: 28),
            
            scoreLabel.centerXAnchor.constraint(equalTo: scoreContainer.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: scoreContainer.centerYAnchor),
            
            // Home Team Layout (Left)
            homeNameLabel.trailingAnchor.constraint(equalTo: scoreContainer.leadingAnchor, constant: -12),
            homeNameLabel.centerYAnchor.constraint(equalTo: scoreContainer.centerYAnchor),
            homeNameLabel.leadingAnchor.constraint(equalTo: homeLogoImageView.trailingAnchor, constant: 8),
            
            homeLogoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            homeLogoImageView.centerYAnchor.constraint(equalTo: scoreContainer.centerYAnchor),
            homeLogoImageView.widthAnchor.constraint(equalToConstant: 32),
            homeLogoImageView.heightAnchor.constraint(equalToConstant: 32),
            
            // Away Team Layout (Right)
            awayNameLabel.leadingAnchor.constraint(equalTo: scoreContainer.trailingAnchor, constant: 12),
            awayNameLabel.centerYAnchor.constraint(equalTo: scoreContainer.centerYAnchor),
            awayNameLabel.trailingAnchor.constraint(equalTo: awayLogoImageView.leadingAnchor, constant: -8),
            
            awayLogoImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            awayLogoImageView.centerYAnchor.constraint(equalTo: scoreContainer.centerYAnchor),
            awayLogoImageView.widthAnchor.constraint(equalToConstant: 32),
            awayLogoImageView.heightAnchor.constraint(equalToConstant: 32),
            
            // Date / Time layout
            dateTimeLabel.topAnchor.constraint(equalTo: scoreContainer.bottomAnchor, constant: 6),
            dateTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            dateTimeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            dateTimeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with event: LatestEvent) {
        homeNameLabel.text = event.homeTeamName
        awayNameLabel.text = event.awayTeamName
        scoreLabel.text = "\(event.homeScore) - \(event.awayScore)"
        dateTimeLabel.text = "📅 \(event.date)   🕒 \(event.time)"
        
        let placeholder = UIImage(systemName: "shield.fill")
        homeLogoImageView.loadImage(from: event.homeTeamLogo, placeholder: placeholder)
        awayLogoImageView.loadImage(from: event.awayTeamLogo, placeholder: placeholder)
    }
}
