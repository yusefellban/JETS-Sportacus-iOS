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
    @IBOutlet weak var actionButton: UIButton!
    
    var onActionTapped: (() -> Void)?
    
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
        
        // Add subtle premium drop shadow to the cell container card
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.masksToBounds = false
        
        badgeImageView.layer.cornerRadius = 25
        badgeImageView.clipsToBounds = true
        badgeImageView.backgroundColor = .systemGray6
        
        flagImageView.layer.cornerRadius = 9
        flagImageView.clipsToBounds = true
        flagImageView.backgroundColor = .systemGray6
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        onActionTapped?()
    }
    
    func configure(with league: League, isFavorite: Bool, isFavoritesScreen: Bool, placeholderImageName: String = "trophy.circle.fill") {
        nameLabel.text = league.leagueName
        countryLabel.text = league.countryName
        
        let placeholder = UIImage(systemName: placeholderImageName) ?? UIImage(systemName: "trophy.circle.fill")
        badgeImageView.tintColor = UIColor(named: "LimeNeon") ?? .systemGreen
        badgeImageView.loadImage(from: league.leagueLogo, placeholder: placeholder)
        
        flagImageView.image = UIImage(systemName: "globe")
        flagImageView.tintColor = .systemGray2
        
        if isFavoritesScreen {
            // Delete button for favorites screen
            actionButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
            actionButton.tintColor = .systemRed
        } else {
            // Heart button for leagues screen
            let heartImage = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            actionButton.setImage(heartImage, for: .normal)
            actionButton.tintColor = isFavorite ? .systemRed : .systemGray3
        }
    }
}
