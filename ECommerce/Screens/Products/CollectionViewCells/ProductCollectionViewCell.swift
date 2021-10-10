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

    /// The closure called when the add button gets tapped.
    var addProductTapCompletion: (() -> ())?

    /// The closure called when the remove button gets tapped.
    var removeProductTapCompletion: (() -> ())?

    // Outlet connections.
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemImageView: ProductImageView!
    @IBOutlet weak var informationContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderControlsContainerView: UIView!
    @IBOutlet weak var removeProductButton: UIButton!
    @IBOutlet weak var addedCountLabel: UILabel!
    @IBOutlet weak var addProductButton: UIButton!

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

        orderControlsContainerView.layer.cornerRadius = 10
        removeProductButton.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .disabled)
        removeProductButton.setTitleColor(.black, for: .normal)
        removeProductButton.isEnabled = false
        addedCountLabel.text = "0"
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

    func setProductCount(productCount: Int) {
        addedCountLabel.text = "\(productCount)"
        removeProductButton.isEnabled = productCount > 0 ? true : false
    }

    @IBAction func addProductTapped(_ sender: Any) {
        addProductTapCompletion?()
    }

    @IBAction func removeProductTapped(_ sender: Any) {
        removeProductTapCompletion?()
    }
}
