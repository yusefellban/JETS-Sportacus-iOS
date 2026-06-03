import UIKit

class TeamDetailsViewController: UIViewController {
    
    // team is set either via the designated init (programmatic push)
    // or via the `configure(with:)` method when loaded from storyboard.
    private var team: Team = Team(teamName: "", logoName: "")
    
    // UI Elements
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 60
        iv.layer.borderWidth = 3
        iv.layer.borderColor = (UIColor(named: "LimeNeon") ?? .systemGreen).cgColor
        iv.backgroundColor = .white
        iv.tintColor = UIColor(named: "LimeNeon") ?? .systemGreen
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    init(team: Team) {
        self.team = team
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Call this when instantiating from storyboard before viewDidLoad.
    func configure(with team: Team) {
        self.team = team
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = team.teamName
        view.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 250/255, alpha: 1.0)
        
        setupViews()
        configureViews()
    }
    
    private func setupViews() {
        view.addSubview(logoImageView)
        view.addSubview(nameLabel)
        view.addSubview(cardView)
        cardView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cardView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            infoStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            infoStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24),
            infoStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            infoStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24)
        ])
    }
    
    private func configureViews() {
        nameLabel.text = team.teamName
        
        if let image = UIImage(named: team.logoName) {
            logoImageView.image = image
        } else if let sysImage = UIImage(systemName: team.logoName) {
            logoImageView.image = sysImage
        } else {
            logoImageView.image = UIImage(systemName: "shield.fill")
        }
        
        
        addInfoRow(title: "⚽ Type", value: "Football Club")
        addInfoRow(title: "📅 Founded", value: "1905 (Mocked)")
        addInfoRow(title: "🏟️ Stadium", value: "Championship Ground")
        addInfoRow(title: "📍 Location", value: "Europe / Local")
    }
    
    private func addInfoRow(title: String, value: String) {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.distribution = .equalSpacing
        
        let titleLabel = UILabel()
        titleLabel.textColor = .systemGray
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.text = title
        
        let valueLabel = UILabel()
        valueLabel.textColor = .black
        valueLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        valueLabel.text = value
        
        rowStack.addArrangedSubview(titleLabel)
        rowStack.addArrangedSubview(valueLabel)
        
        infoStackView.addArrangedSubview(rowStack)
    }
}
