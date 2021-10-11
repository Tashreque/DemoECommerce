//
//  OrderSuccessViewController.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 11/10/21.
//

import UIKit

class OrderSuccessViewController: UIViewController {

    // Storyboard outlet connections.
    @IBOutlet weak var successMessageContainerView: UIView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUIComponents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide navigation bar.
        self.navigationController?.isNavigationBarHidden = true
    }

    private func setupUIComponents() {
        successMessageContainerView.backgroundColor = .brown
        successMessageContainerView.layer.cornerRadius = 125
        successMessageContainerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        successMessageContainerView.layer.shadowRadius = 4
        successMessageContainerView.layer.shadowOpacity = 1
        successMessageContainerView.layer.shadowOffset = CGSize(width: 3, height: 3)

        successLabel.text = "Order placed!"
        successLabel.textColor = .white
        successLabel.numberOfLines = 0

        dismissButton.layer.cornerRadius = 24
        dismissButton.backgroundColor = .brown
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.setTitleColor(.white, for: .normal)
    }

    @IBAction func dismissTapped(_ sender: Any) {
        self.popMultipleViewControllers(numberToPop: 2, animated: true)
    }
}
