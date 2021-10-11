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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide navigation bar.
        self.navigationController?.isNavigationBarHidden = false
    }

    private func bindViewModel() {
        // Initialize view model.
        viewModel = ProductsViewModel(networkManager: NetworkManager.shared)

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

        viewModel.showAlert = { [weak self] errorMessage in
            if let errorMessage = errorMessage {
                self?.showDefaultAlert(title: errorMessage, message: "")
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
        orderSummaryButton.backgroundColor = .brown
        orderSummaryButton.setTitle("Order Summary", for: .normal)
        orderSummaryButton.setTitleColor(.white, for: .normal)
        orderSummaryButton.disableButton(withAlpha: 0.5)
    }

    private func toggleOrderSummaryButton(shouldEnable: Bool) {
        if shouldEnable {
            orderSummaryButton.enableButton()
        } else {
            orderSummaryButton.disableButton(withAlpha: 0.5)
        }
    }

    @IBAction func didTapOrderSummary(_ sender: Any) {
        let controller = self.getControllerFromStoryboard(storyboardName: StoryboardName.main, classIdentifier: String(describing: OrderSummaryViewController.self)) as! OrderSummaryViewController
        controller.orderDict = viewModel.productOrderCountDict
        controller.products = viewModel.products
        self.navigationController?.pushViewController(controller, animated: true)
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
            self.viewModel.productOrderCountDict = orderDict
            self.toggleOrderSummaryButton(shouldEnable: self.viewModel.productOrderCountDict.count > 0)
        }
        return cell
    }
}

