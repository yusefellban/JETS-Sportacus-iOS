//
//  SportCategoryCollectionViewCell.swift
//  sportacus
//
//  Created by Noureldeen on 03/06/2026.
//

import UIKit

class SportCategoryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SportCategoryCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyles()
    }
    
    private func setupStyles() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 24
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor(named: "LimeNeon")?.cgColor ?? UIColor.green.cgColor
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
