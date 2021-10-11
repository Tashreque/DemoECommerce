//
//  StoreInfoTableViewCell.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 9/10/21.
//

import UIKit

class StoreInfoTableViewCell: UITableViewCell {

    // Outlet connections.
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var openingTimeLabel: UILabel!
    @IBOutlet weak var closingTimeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ratingIconImageView: UIImageView!

    /// The cell reuse identifier.
    static let identifier = String(describing: StoreInfoTableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUIComponents()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupUIComponents() {
        self.selectionStyle = .none
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .brown
        openingTimeLabel.numberOfLines = 0
        openingTimeLabel.textColor = .brown
        closingTimeLabel.numberOfLines = 0
        closingTimeLabel.textColor = .brown
        ratingIconImageView.image = UIImage(named: "starFill")

        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 4
    }

    func configureCell(withInfo storeInfo: StoreInfo?) {
        if let info = storeInfo {
            titleLabel.text = info.name ?? ""
            if let rating = info.rating {
                ratingLabel.text = String(rating)
            }

            if let openingTime = info.openingTime {
                openingTimeLabel.text = "Opens at: \(openingTime)"
            }

            if let closingTime = info.closingTime {
                closingTimeLabel.text = "Closes at: \(closingTime)"
            }
        }
    }
    
}
