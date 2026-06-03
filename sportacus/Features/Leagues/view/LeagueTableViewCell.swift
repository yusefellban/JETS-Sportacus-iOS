//
//  LeagueTableViewCell.swift
//  sportacus
//
//  Created by Noureldeen on 03/06/2026.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "LeagueTableViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyles()
    }
    
    private func setupStyles() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.systemGray5.cgColor
        
        badgeImageView.layer.cornerRadius = 25
        badgeImageView.clipsToBounds = true
        badgeImageView.backgroundColor = .systemGray6
        
        flagImageView.layer.cornerRadius = 9
        flagImageView.clipsToBounds = true
        flagImageView.backgroundColor = .systemGray6
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
