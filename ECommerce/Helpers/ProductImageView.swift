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
    func loadImage(fromUrlString urlString: String, contentMode: UIView.ContentMode = .scaleAspectFit) {
        NetworkManager.shared.getImage(fromUrlString: urlString) { (result: Result<Data, NetworkError>) in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.contentMode = contentMode
                        self?.image = image
                    }
                }
            case .failure(let error):
                print("Error downloading image: \(error.localizedDescription)")
            }
        }
    }
}
