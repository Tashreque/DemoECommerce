//
//  ProductCollectionViewCell.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 9/10/21.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    /// The cell reuse identifier.
    static let identifier = String(describing: ProductCollectionViewCell.self)

    // Outlet connections.
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemImageView: ProductImageView!
    @IBOutlet weak var informationContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUIComponents()
    }

    private func setupUIComponents() {
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 4

        itemImageView.layer.cornerRadius = 10
        informationContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        nameLabel.numberOfLines = 0
        informationContainerView.layer.cornerRadius = 10
    }

    func configureCell(name: String?, price: Int?, imageUrlString: String?) {
        self.nameLabel.text = name ?? ""
        if let price = price {
            self.priceLabel.text = "Price: \(price)"
        }

        if let urlString = imageUrlString {
            itemImageView.loadImage(fromUrlString: urlString, contentMode: .scaleAspectFill)
        }
    }

}
