//
//  UIImageView+Extension.swift
//  sportacus
//
//  Created by Noureldeen on 05/06/2026.
//

import UIKit
import ObjectiveC

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

extension UIImageView {
    private static var taskKey = 0
    private static var urlKey = 0
    
    private var currentTask: URLSessionDataTask? {
        get { objc_getAssociatedObject(self, &Self.taskKey) as? URLSessionDataTask }
        set { objc_setAssociatedObject(self, &Self.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var currentURL: String? {
        get { objc_getAssociatedObject(self, &Self.urlKey) as? String }
        set { objc_setAssociatedObject(self, &Self.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func loadImage(from urlString: String?, placeholder: UIImage?) {
        // Cancel any existing download task for this image view
        currentTask?.cancel()
        currentTask = nil
        currentURL = nil
        
        // Show placeholder initially
        self.image = placeholder
        
        guard let urlString = urlString, !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        // Check if it is a remote image URL
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
            let cacheKey = NSString(string: urlString)
            
            // Check memory cache
            if let cachedImage = ImageCache.shared.object(forKey: cacheKey) {
                self.image = cachedImage
                return
            }
            
            guard let url = URL(string: urlString) else { return }
            currentURL = urlString
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                guard error == nil, let data = data, let downloadedImage = UIImage(data: data) else { return }
                
                ImageCache.shared.setObject(downloadedImage, forKey: cacheKey)
                
                DispatchQueue.main.async {
                    if self.currentURL == urlString {
                        self.image = downloadedImage
                    }
                }
            }
            currentTask = task
            task.resume()
        } else {
            // Treat as local asset name
            if let localImage = UIImage(named: urlString) {
                self.image = localImage
            }
        }
    }
}
