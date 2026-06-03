import UIKit

class SportCategoryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SportCategoryCollectionViewCell"
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "DeepForestNight") ?? .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 24
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor(named: "LimeNeon")?.cgColor ?? UIColor.green.cgColor
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleContainer)
        titleContainer.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // Image View
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleContainer.topAnchor),
            
            // Title Container
            titleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleContainer.heightAnchor.constraint(equalToConstant: 50),
            
            // Title Label
            titleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with sport: Sport) {
        titleLabel.text = sport.displayName
        if let image = UIImage(named: sport.imageName) {
            imageView.image = image
        } else {
            imageView.image = UIImage(systemName: "sportscourt")
        }
    }
}
