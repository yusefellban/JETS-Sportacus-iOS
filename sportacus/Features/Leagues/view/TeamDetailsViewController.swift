import UIKit

class TeamDetailsViewController: UIViewController {
    
    // team is set via `configure(with:)` before the view loads
    private var team: Team = Team(teamKey: 0, teamName: "", logoName: "", playersCount: 0, coachName: nil)
    
    // MARK: - IBOutlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var infoStackView: UIStackView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Call this immediately after instantiating from storyboard, before the view loads.
    func configure(with team: Team) {
        self.team = team
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = team.teamName
        
        // Apply layer properties — CALayer colors cannot reference named colors in storyboard
        logoImageView.layer.cornerRadius = 60
        logoImageView.layer.borderWidth = 3
        logoImageView.layer.borderColor = (UIColor(named: "LimeNeon") ?? .systemGreen).cgColor
        logoImageView.backgroundColor = .white
        logoImageView.tintColor = UIColor(named: "LimeNeon") ?? .systemGreen
        
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)
        cardView.layer.shadowRadius = 12
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray6.cgColor
        
        configureViews()
    }
    
    private func configureViews() {
        nameLabel.text = team.teamName
        
        let placeholder = UIImage(systemName: "shield.fill")
        logoImageView.loadImage(from: team.logoName, placeholder: placeholder)
        
        // Clear old mock views
        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        addInfoRow(title: "⚽ Type", value: "Football Club")
        
        if let coach = team.coachName, !coach.isEmpty {
            addInfoRow(title: "👨‍💼 Coach", value: coach)
        } else {
            addInfoRow(title: "👨‍💼 Coach", value: "Unknown")
        }
        
        addInfoRow(title: "👥 Players", value: "\(team.playersCount > 0 ? "\(team.playersCount)" : "N/A")")
        addInfoRow(title: "🔑 Team ID", value: "\(team.teamKey)")
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
