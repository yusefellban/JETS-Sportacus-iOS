//
//  SportsViewController.swift
//  sportacus
//
//  Created by Noureldeen on 02/06/2026.
//

import UIKit

class SportsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SportsViewProtocol {
    
    var presenter: SportsPresenterProtocol?
    private var sports: [Sport] = []
    
    // Loading indicator
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(named: "LimeNeon") ?? .systemGreen
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sports"
        
        setupBackground()
        setupCollectionView()
        setupLoadingIndicator()
        
        // Notify presenter that view is ready
        presenter?.viewDidLoad()
    }
    
    private func setupBackground() {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        if let bgImage = UIImage(named: "screen_bg") {
            bgImageView.image = bgImage
        } else {
            bgImageView.backgroundColor = UIColor(named: "DeepForestNight") ?? .systemBackground
        }
        collectionView.backgroundView = bgImageView
    }
    
    private func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - SportsViewProtocol
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func displaySports(_ sports: [Sport]) {
        self.sports = sports
        collectionView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func navigateToLeagues(for sport: Sport) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesTableViewController") as? LeaguesTableViewController else { return }
        let leaguesPresenter = LeaguesPresenter(view: leaguesVC)
        leaguesVC.presenter = leaguesPresenter
        navigationController?.pushViewController(leaguesVC, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SportCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! SportCategoryCollectionViewCell
        cell.configure(with: sports[indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.selectSport(at: indexPath.item)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let spacing: CGFloat = 16
        let totalHorizontalPadding = padding * 2 + spacing
        let availableWidth = collectionView.bounds.width - totalHorizontalPadding
        let itemWidth = availableWidth / 2
        
        let itemHeight = itemWidth * 1.2
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
