//
//  ProductsViewModel.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 9/10/21.
//

import Foundation

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

    /// The dictionary to keep track of the products and the amount ordered.
    var productOrderCountDict: SelectedProductDictionary = [String : Int]()

    // Network manager shared instance.
    private var networkManager: NetworkManagerDelegate!

    init(networkManager: NetworkManagerDelegate) {
        self.networkManager = networkManager
        retrieveAllInformation()
    }

    func retrieveAllInformation() {
        let taskGroup = DispatchGroup()
        var retrievedErrorMessage: String?

        // Get store information.
        taskGroup.enter()
        getStoreInformation { [weak self] (storeInfo, errorMessage) in
            self?.storeInformation = storeInfo
            retrievedErrorMessage = errorMessage
            taskGroup.leave()
        }

        // Get product list.
        taskGroup.enter()
        getProductList { [weak self] (products, errorMessage) in
            self?.products = products ?? []
            retrievedErrorMessage = errorMessage
            taskGroup.leave()
        }

        // Get notified when both tasks are complete.
        taskGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.numberOfItemsToBeDisplayed = 2
            self.bindStoreAndProductInfo?()
            self.showAlert?(retrievedErrorMessage)
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
}
