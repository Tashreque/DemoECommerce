//
//  OrderSummaryTableViewCell.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 11/10/21.
//

import UIKit

class OrderSummaryTableViewCell: UITableViewCell {

    /// The identifier for this cell.
    static let identifier = String(describing: OrderSummaryTableViewCell.self)

    // The outlet connections.
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var productUnitPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUIComponents()
    }

    private func setupUIComponents() {
        self.selectionStyle = .none
        productNameLabel.textColor = .brown
        productCountLabel.textColor = .black
        productUnitPriceLabel.textColor = .brown
    }

    func configureCell(product: Product, count: Int) {
        productNameLabel.text = product.name ?? ""
        if let price = product.price {
            productUnitPriceLabel.text = "\(price)"
        }
        productCountLabel.text = "x\(count)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
