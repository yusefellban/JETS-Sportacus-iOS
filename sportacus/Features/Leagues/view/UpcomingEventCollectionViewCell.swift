import UIKit

class UpcomingEventCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "UpcomingEventCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let eventNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let homeLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.backgroundColor = UIColor.systemGray6
        iv.tintColor = UIColor(named: "LimeNeon") ?? .systemGreen
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let awayLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.backgroundColor = UIColor.systemGray6
        iv.tintColor = UIColor(named: "LimeNeon") ?? .systemGreen
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let vsLabel: UILabel = {
        let label = UILabel()
        label.text = "VS"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
        containerView.addSubview(eventNameLabel)
        containerView.addSubview(homeLogoImageView)
        containerView.addSubview(vsLabel)
        containerView.addSubview(awayLogoImageView)
        containerView.addSubview(dateTimeLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            eventNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            eventNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            eventNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            // Logos Layout
            vsLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 4),
            vsLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            homeLogoImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 4),
            homeLogoImageView.trailingAnchor.constraint(equalTo: vsLabel.leadingAnchor, constant: -24),
            homeLogoImageView.widthAnchor.constraint(equalToConstant: 48),
            homeLogoImageView.heightAnchor.constraint(equalToConstant: 48),
            
            awayLogoImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 4),
            awayLogoImageView.leadingAnchor.constraint(equalTo: vsLabel.trailingAnchor, constant: 24),
            awayLogoImageView.widthAnchor.constraint(equalToConstant: 48),
            awayLogoImageView.heightAnchor.constraint(equalToConstant: 48),
            
            dateTimeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            dateTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            dateTimeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }
    
    func configure(with event: UpcomingEvent) {
        eventNameLabel.text = event.eventName
        dateTimeLabel.text = "📅 \(event.date)  🕒 \(event.time)"
        
        // Setup image placeholders/symbols
        if let image = UIImage(named: event.homeTeamLogo) {
            homeLogoImageView.image = image
        } else if let sysImage = UIImage(systemName: event.homeTeamLogo) {
            homeLogoImageView.image = sysImage
        } else {
            homeLogoImageView.image = UIImage(systemName: "shield.fill")
        }
        
        if let image = UIImage(named: event.awayTeamLogo) {
            awayLogoImageView.image = image
        } else if let sysImage = UIImage(systemName: event.awayTeamLogo) {
            awayLogoImageView.image = sysImage
        } else {
            awayLogoImageView.image = UIImage(systemName: "shield.fill")
        }
    }
}
