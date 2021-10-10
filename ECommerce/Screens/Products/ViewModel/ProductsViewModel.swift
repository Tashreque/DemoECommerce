//
//  ProductsViewModel.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 9/10/21.
//

import Foundation

typealias NetworkErrorMessage = String?

class ProductsViewModel {

    /// The closure which is called in order to bind information with the corresponding view controller.
    var bindStoreAndProductInfo: (() -> ())?

    /// The closure which is called in order to let the controller know that an alert needs to be shown.
    var showAlert: ((NetworkErrorMessage) -> ())?

    /// The store information object.
    var storeInformation: StoreInfo!

    /// The product list.
    var products = [Product]()

    /// The number of items to be displayed.
    var numberOfItemsToBeDisplayed = 0

    /// The total price.
    var totalPrice = 0

    // The dictionary to keep track of the products and the amount ordered.
    private var productOrderCountDict = [String : Int]()

    // Network manager shared instance.
    let networkManager = NetworkManager.shared

    init() {
        retrieveAllInformation()
    }

    private func retrieveAllInformation() {
        let taskGroup = DispatchGroup()

        // Get store information.
        taskGroup.enter()
        getStoreInformation { [weak self] (storeInfo, errorMessage) in
            self?.storeInformation = storeInfo
            taskGroup.leave()
        }

        // Get product list.
        taskGroup.enter()
        getProductList { [weak self] (products, errorMessage) in
            self?.products = products ?? []
            taskGroup.leave()
        }

        // Get notified when both tasks are complete.
        taskGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.numberOfItemsToBeDisplayed = 2
            self.bindStoreAndProductInfo?()
        }
    }

    func getStoreInformation(completion: @escaping (StoreInfo?, NetworkErrorMessage) -> ()) {
        networkManager.getRequest(endpoint: StoreEndpoint.storeInfo) { (result: Result<StoreInfo, NetworkError>) in
            switch result {
            case .success(let storeInfo):
                completion(storeInfo, nil)
            case .failure(let error):
                print(error.errorMessage)
                completion(nil, error.errorMessage)
            }
        }
    }

    func getProductList(completion: @escaping ([Product]?, NetworkErrorMessage) -> ()) {
        networkManager.getRequest(endpoint: StoreEndpoint.products) { (result: Result<[Product], NetworkError>) in
            switch result {
            case .success(let products):
                completion(products, nil)
            case .failure(let error):
                print(error.errorMessage)
                completion(nil, error.errorMessage)
            }
        }
    }

    func updatePrice(orderDict: [String : Int]) {
        productOrderCountDict = orderDict

        // Calculate price
        var price = 0
        for product in products {
            let productName = product.name ?? ""
            let productPrice = product.price ?? 0
            if let itemCount = productOrderCountDict[productName] {
                let totalItemPrice = itemCount * productPrice
                price += totalItemPrice
            }
        }
        totalPrice = price
        print("Total price = \(totalPrice)")
    }
}
