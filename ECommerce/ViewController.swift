//
//  ViewController.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 7/10/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        NetworkManager.shared.getRequest(endpoint: StoreEndpoint.products) { (result: Result<[Product], Error>) in
            switch result {
            case .success(let productList):
                print("Count = \(productList.count)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}

