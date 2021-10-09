//
//  ProductListTableViewCell.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 9/10/21.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {

    /// The cell reuse identifier.
    static let identifier = String(describing: ProductListTableViewCell.self)

    // The product list.
    var products = [Product]()

    /// The height of the UITableViewCell.
    var height: CGFloat = 600
    var width: CGFloat = 400

    // Outlet connections.
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

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
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        productCollectionView.showsHorizontalScrollIndicator = false
        collectionViewHeightConstraint.constant = height

        productCollectionView.register(UINib(nibName: ProductCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }

    func configureCell(withProducts products: [Product], cellHeight: CGFloat = 600, cellWidth: CGFloat = 400) {
        self.products = products
        self.height = cellHeight
        self.width = cellWidth
        DispatchQueue.main.async { [weak self] in
            self?.productCollectionView.reloadData()
        }
    }

}

extension ProductListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        let product = products[indexPath.row]
        cell.configureCell(name: product.name, price: product.price, imageUrlString: product.imageUrl)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: height)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}


