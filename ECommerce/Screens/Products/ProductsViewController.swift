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
    @IBOutlet weak var orderSummaryBottomConstraint: NSLayoutConstraint!

    // View controller specific constants
    let orderSummaryConstraintChange: CGFloat = 100
    let orderSummaryConstraintOffset: CGFloat = 16
    let itemCount = 2

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
        orderSummaryButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        orderSummaryButton.layer.shadowOpacity = 1
        orderSummaryButton.layer.shadowRadius = 8
        orderSummaryButton.layer.shadowOffset = .zero
    }

    private func toggleOrderSummaryButton(shouldShow: Bool) {
        let animationOption = shouldShow ? UIView.AnimationOptions.curveEaseOut : UIView.AnimationOptions.curveEaseIn
        UIView.animate(withDuration: 0.3, delay: 0, options: animationOption) { [weak self] in
            guard let self = self else { return }

            let change = self.orderSummaryConstraintChange + self.orderSummaryConstraintOffset
            if shouldShow {
                self.orderSummaryBottomConstraint.constant += change
            } else {
                self.orderSummaryBottomConstraint.constant -= change
            }
            self.view.layoutIfNeeded()
        } completion: { _ in
            print("Toggled order summary button.")
        }
    }

    @IBAction func didTapOrderSummary(_ sender: Any) {
        
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: StoreInfoTableViewCell.identifier, for: indexPath) as! StoreInfoTableViewCell
            cell.configureCell(withInfo: viewModel.storeInformation)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier, for: indexPath) as! ProductListTableViewCell
        let cellWidth = 0.80 * self.view.bounds.width
        let cellHeight = 0.60 * self.view.bounds.height
        cell.configureCell(withProducts: viewModel.products, cellHeight: cellHeight, cellWidth: cellWidth)
        return cell
    }
}

