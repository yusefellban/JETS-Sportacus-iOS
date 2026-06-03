//
//  LeagueTableViewCell.swift
//  sportacus
//
//  Created by Noureldeen on 02/06/2026.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "LeagueTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let badgeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.backgroundColor = .systemGray6
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let flagImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 9
        iv.backgroundColor = .systemGray6
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(badgeImageView)
        containerView.addSubview(chevronImageView)
        
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.spacing = 6
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textStackView)
        
        textStackView.addArrangedSubview(nameLabel)
        
        let countryStackView = UIStackView()
        countryStackView.axis = .horizontal
        countryStackView.spacing = 6
        countryStackView.alignment = .center
        
        countryStackView.addArrangedSubview(flagImageView)
        countryStackView.addArrangedSubview(countryLabel)
        textStackView.addArrangedSubview(countryStackView)
        
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Badge Image View
            badgeImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            badgeImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            badgeImageView.widthAnchor.constraint(equalToConstant: 50),
            badgeImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Chevron Image View
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Text Stack View
            textStackView.leadingAnchor.constraint(equalTo: badgeImageView.trailingAnchor, constant: 16),
            textStackView.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            textStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            // Flag image constraints
            flagImageView.widthAnchor.constraint(equalToConstant: 18),
            flagImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func configure(with league: League) {
        nameLabel.text = league.leagueName
        countryLabel.text = league.countryName
        
        // Setup image placeholders or loaded images
        if let logoName = league.leagueLogo, let logoImage = UIImage(named: logoName) {
            badgeImageView.image = logoImage
        } else {
            badgeImageView.image = UIImage(systemName: "trophy.circle.fill")
            badgeImageView.tintColor = UIColor(named: "LimeNeon") ?? .systemGreen
        }
        
        // Setup country flag placeholder or system image
        flagImageView.image = UIImage(systemName: "globe")
        flagImageView.tintColor = .systemGray2
    }
}
