//
//  OrderSummaryViewController.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 10/10/21.
//

import UIKit

class OrderSummaryViewController: UIViewController {

    /// The ordered product dictionary which must be set.
    var orderDict: SelectedProductDictionary = [String : Int]()

    // Storyboard outlet connections.
    @IBOutlet weak var orderProductTableView: UITableView!
    @IBOutlet weak var confirmOrderButton: UIButton!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!

    /// The list of available products. This property must be assigned before this UIViewController instance is displayed.
    var products = [Product]()

    // The view model instance for this UIViewController class.
    var viewModel: OrderSummaryViewModel!

    // Class specific constants.
    let cellHeight: CGFloat = 80

    // The spinner view to be shown.
    var spinnerContainerView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUIComponents()
        bindViewModel()
        self.hideKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide navigation bar.
        self.navigationController?.isNavigationBarHidden = false
    }

    private func setupUIComponents() {
        self.title = "Order Summary"
        orderProductTableView.delegate = self
        orderProductTableView.dataSource = self
        orderProductTableView.separatorStyle = .none
        orderProductTableView.register(UINib(nibName: OrderSummaryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrderSummaryTableViewCell.identifier)

        totalPriceLabel.textColor = .brown
        addressTextView.setBorder(borderWidth: 2, color: .brown)
        addressTextView.layer.cornerRadius = 10
        addressTextView.tintColor = .brown
        addressTextView.delegate = self

        confirmOrderButton.layer.cornerRadius = 24
        confirmOrderButton.setTitle("Confirm Order", for: .normal)
        confirmOrderButton.setTitleColor(.white, for: .normal)
        confirmOrderButton.backgroundColor = .brown
        confirmOrderButton.disableButton(withAlpha: 0.5)

        deliveryAddressLabel.textColor = .brown
        deliveryAddressLabel.text = "Enter delivery address:"
        itemLabel.textColor = .black
        itemLabel.text = "Item"
        priceLabel.textColor = .black
        priceLabel.text = "Unit Price"
    }

    private func bindViewModel() {
        viewModel = OrderSummaryViewModel(products: products, orderDict: orderDict, networkManager: NetworkManager.shared)
        viewModel.generateUniqueProductList(orderDict: orderDict)
        self.totalPriceLabel.text = "Total: \(self.viewModel.calculatePrice(products: self.products, orderDict: self.orderDict))"
        self.orderProductTableView.reloadData()
    }

    private func toggleConfirmOrderButton(shouldEnable: Bool) {
        if shouldEnable {
            confirmOrderButton.enableButton()
        } else {
            confirmOrderButton.disableButton(withAlpha: 0.5)
        }
    }

    private func showDefaultSpinner(backgroundColor: UIColor?, backgroundAlpha: CGFloat, spinnerColor: UIColor?) {
        let containerView = UIView(frame: self.view.bounds)
        containerView.backgroundColor = backgroundColor?.withAlphaComponent(backgroundAlpha)

        let spinner = UIActivityIndicatorView()
        spinner.color = spinnerColor
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(containerView)
        containerView.addSubview(spinner)

        NSLayoutConstraint.activate([spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor), spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)])
        spinnerContainerView = containerView
    }

    private func hideSpinner() {
        if let spinnerContainerView = self.spinnerContainerView {
            spinnerContainerView.removeFromSuperview()
            self.spinnerContainerView = nil
        }
    }

    @IBAction func confirmOrderTapped(_ sender: Any) {
        self.showDefaultSpinner(backgroundColor: .brown, backgroundAlpha: 0.3, spinnerColor: .brown)
        viewModel.placeOrder(address: addressTextView.text) { [weak self] (isSuccess, errorMessage) in
            guard let self = self else { return }
            if isSuccess {
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.goToSuccessViewController()
                }
            }

            if let errorMessage = errorMessage {
                self.showDefaultAlert(title: errorMessage ?? "", message: "")
            }
        }
    }

    func goToSuccessViewController() {
        let controller = self.getControllerFromStoryboard(storyboardName: StoryboardName.main, classIdentifier: String(describing: OrderSuccessViewController.self)) as! OrderSuccessViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension OrderSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.uniqueProductsToOrder.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderSummaryTableViewCell.identifier, for: indexPath) as! OrderSummaryTableViewCell
        let product = viewModel.uniqueProductsToOrder[indexPath.row]
        let productCount = viewModel.getNumberOfItemsToOrder(productName: product.name ?? "", orderDict: orderDict)
        cell.configureCell(product: product, count: productCount)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

extension OrderSummaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            if text.count > 0 {
                toggleConfirmOrderButton(shouldEnable: true)
            } else {
                toggleConfirmOrderButton(shouldEnable: false)
            }
        }
    }
}
