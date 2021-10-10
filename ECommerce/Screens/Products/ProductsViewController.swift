//
//  ViewController.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 7/10/21.
//

import UIKit

class ProductsViewController: UIViewController {

    // View model reference
    var viewModel: ProductsViewModel!

    // Storyboard outlet connections
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var orderSummaryButton: UIButton!

    // View controller specific constants
    let orderSummaryConstraintChange: CGFloat = 100
    let orderSummaryConstraintOffset: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        bindViewModel()
        setupUIComponents()
    }

    private func bindViewModel() {
        // Initialize view model.
        viewModel = ProductsViewModel()

        // Bind view controller to view model.
        viewModel.bindStoreAndProductInfo = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let storeInfo = self.viewModel.storeInformation {
                    print("StoreName = \(storeInfo.name ?? "")")
                }
                print("Product count = \(self.viewModel.products.count)")

                self.productTableView.reloadData()
            }
        }
    }

    private func setupUIComponents() {
        self.title = "Products"
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.separatorStyle = .none
        productTableView.showsVerticalScrollIndicator = false

        productTableView.register(UINib(nibName: StoreInfoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: StoreInfoTableViewCell.identifier)
        productTableView.register(UINib(nibName: ProductListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProductListTableViewCell.identifier)

        orderSummaryButton.layer.cornerRadius = 24
        orderSummaryButton.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        orderSummaryButton.isEnabled = false
        orderSummaryButton.setTitle("Order Summary", for: .normal)
        orderSummaryButton.setTitleColor(.white, for: .normal)
    }

    private func toggleOrderSummaryButton(shouldEnable: Bool) {
        if shouldEnable {
            orderSummaryButton.backgroundColor = .brown
            orderSummaryButton.isEnabled = true
        } else {
            orderSummaryButton.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
            orderSummaryButton.isEnabled = false
        }
    }

    @IBAction func didTapOrderSummary(_ sender: Any) {
        
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsToBeDisplayed
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: StoreInfoTableViewCell.identifier, for: indexPath) as! StoreInfoTableViewCell
            cell.configureCell(withInfo: viewModel.storeInformation)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier, for: indexPath) as! ProductListTableViewCell
        let cellWidth = 0.75 * self.view.bounds.width
        let cellHeight = 0.60 * self.view.bounds.height
        cell.configureCell(withProducts: viewModel.products, cellHeight: cellHeight, cellWidth: cellWidth)
        cell.orderListUpdated = { [weak self] (orderDict) in
            guard let self = self else { return }
            self.viewModel.updatePrice(orderDict: orderDict)
            self.toggleOrderSummaryButton(shouldEnable: self.viewModel.totalPrice > 0)
        }
        return cell
    }
}

