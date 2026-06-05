import UIKit

class TeamCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TeamCollectionViewCell"
    
    private let teamLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 32
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.systemGray5.cgColor
        iv.backgroundColor = .white
        iv.tintColor = UIColor(named: "LimeNeon") ?? .systemGreen
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let teamNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
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
        contentView.addSubview(teamLogoImageView)
        contentView.addSubview(teamNameLabel)
        
        NSLayoutConstraint.activate([
            teamLogoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            teamLogoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            teamLogoImageView.widthAnchor.constraint(equalToConstant: 64),
            teamLogoImageView.heightAnchor.constraint(equalToConstant: 64),
            
            teamNameLabel.topAnchor.constraint(equalTo: teamLogoImageView.bottomAnchor, constant: 6),
            teamNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            teamNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            teamNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    func configure(with team: Team) {
        teamNameLabel.text = team.teamName
        
        let placeholder = UIImage(systemName: "shield.fill")
        teamLogoImageView.loadImage(from: team.logoName, placeholder: placeholder)
    }
}
