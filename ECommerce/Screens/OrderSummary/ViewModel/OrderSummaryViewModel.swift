//
//  OrderSummaryViewModel.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 10/10/21.
//

import Foundation

class OrderSummaryViewModel {

    /// The list of products to be ordered. This list may contain a single product several times depending on the number of the item chosen.
    var productsToOrder = [Product]()

    /// The unique names of the products to be ordered.
    var uniqueProductsToOrder = [Product]()

    init(products: [Product], orderDict: SelectedProductDictionary) {
        createProductListForOrder(products: products, orderDict: orderDict)
    }

    private func createProductListForOrder(products: [Product], orderDict: SelectedProductDictionary) {
        var allProductDict = [String : Product]()
        var productsToOrder = [Product]()

        // Create a dictionary of all products.
        for product in products {
            let productName = product.name ?? ""
            allProductDict[productName] = product
        }

        // Form list of products to order.
        for product in products {
            let productName = product.name ?? ""
            if let itemCount = orderDict[productName] {
                for _ in 0..<itemCount {
                    productsToOrder.append(allProductDict[productName]!)
                }
            }
        }
        self.productsToOrder = productsToOrder
    }

    func generateUniqueProductList(orderDict: SelectedProductDictionary) {
        var uniqueProductsToOrder = [Product]()
        var tempDict = orderDict
        for product in productsToOrder {
            let productName = product.name ?? ""
            if tempDict[productName] != nil {
                uniqueProductsToOrder.append(product)
                tempDict[productName] = nil
            }
        }

        self.uniqueProductsToOrder = uniqueProductsToOrder
    }

    func calculatePrice(products: [Product], orderDict: SelectedProductDictionary) -> Int {
        // Calculate price
        var totalPrice = 0
        for product in products {
            let productName = product.name ?? ""
            let productPrice = product.price ?? 0
            if let itemCount = orderDict[productName] {
                let totalItemPrice = itemCount * productPrice
                totalPrice += totalItemPrice
            }
        }
        print("Total price = \(totalPrice)")

        return totalPrice
    }

    func getNumberOfItemsToOrder(productName: String, orderDict: SelectedProductDictionary) -> Int {
        if let count = orderDict[productName] {
            return count
        }
        return 0
    }

    func placeOrder(address: String, completion: @escaping (Bool, NetworkErrorMessage?) -> ()) {
        let order = Order(products: productsToOrder, deliveryAddress: address)
        NetworkManager.shared.uploadRequest(requestBody: order, endpoint: StoreEndpoint.order) { (error) in
            if let error = error {
                completion(false, error.errorMessage)
            } else {
                completion(true, nil)
            }
        }
    }
}
