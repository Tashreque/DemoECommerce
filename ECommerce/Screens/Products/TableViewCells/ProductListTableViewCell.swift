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

    /// The closure which is called when the `productOrderCountDict` gets updated.
    var orderListUpdated: (([String : Int]) -> ())?

    // The product list.
    private var products = [Product]()

    // Product count dictionary.
    private var productOrderCountDict = [String : Int]()

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
        productCollectionView.register(UINib(nibName: ProductCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }

    func configureCell(withProducts products: [Product], cellHeight: CGFloat = 600, cellWidth: CGFloat = 400) {
        self.products = products
        self.height = cellHeight
        self.width = cellWidth
        self.collectionViewHeightConstraint.constant = height
        DispatchQueue.main.async { [weak self] in
            self?.productCollectionView.reloadData()
        }
    }

    private func addToProductDictionary(product: Product) {
        let productName = product.name ?? ""
        if let count = self.productOrderCountDict[productName] {
            let updatedCount = count + 1
            self.productOrderCountDict[productName] = updatedCount
        } else {
            self.productOrderCountDict[productName] = 1
        }
    }

    private func deleteFromProductDictionary(product: Product) {
        let productName = product.name ?? ""
        if let count = self.productOrderCountDict[productName] {
            let updatedCount = count - 1
            self.productOrderCountDict[productName] = updatedCount > 0 ? updatedCount : nil
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

        if let count = self.productOrderCountDict[product.name ?? ""] {
            cell.setProductCount(productCount: count)
        } else {
            cell.setProductCount(productCount: 0)
        }

        cell.addProductTapCompletion = { [weak self] in
            guard let self = self else { return }
            self.addToProductDictionary(product: product)
            self.orderListUpdated?(self.productOrderCountDict)
            collectionView.reloadItems(at: [indexPath])
        }

        cell.removeProductTapCompletion = { [weak self] in
            guard let self = self else { return }
            self.deleteFromProductDictionary(product: product)
            self.orderListUpdated?(self.productOrderCountDict)
            collectionView.reloadItems(at: [indexPath])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: height)
    }
}


