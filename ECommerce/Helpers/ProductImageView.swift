//
//  ProductImageView.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 9/10/21.
//

import Foundation
import UIKit

// Global image cache
class ProductImageView: UIImageView {
    /// The image download task which is used to download and display the image to this UIImageView instance.
    var imageDownloadTask: URLSessionDownloadTask?

    func loadImage(fromUrlString urlString: String, contentMode: UIView.ContentMode = .scaleAspectFit) {
        // Remove currently displayed image.
        self.image = nil

        // Cancel current task to prevent race conditions.
        if let task = imageDownloadTask {
            task.cancel()
        }

        // Check if image is available in cache. If so, show image from cache.
        if let imageFromCache = globalImageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.contentMode = contentMode
            self.image = imageFromCache
            return
        }

        NetworkManager.shared.getImage(fromUrlString: urlString) { [weak self] (result: Result<Data, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {

                    // Store image in global image cache.
                    globalImageCache.setObject(image, forKey: urlString as AnyObject)

                    DispatchQueue.main.async {
                        self.contentMode = contentMode
                        self.image = image
                    }
                }
            case .failure(let error):
                print("Error downloading image: \(error.localizedDescription)")
            }
        } currentDownloadTask: { [weak self] downloadTask in
            self?.imageDownloadTask = downloadTask
        }
    }
}
