//
//  OrderSummaryViewModelTests.swift
//  ECommerceTests
//
//  Created by Tashreque Mohammed Haq on 11/10/21.
//

import XCTest
@testable import ECommerce

class OrderSummaryViewModelTests: XCTestCase {

    var networkManager: MockNetworkManager!
    var model: OrderSummaryViewModel!
    let expectedProductList = [Product(name: "Americano", price: 45, imageUrl: "https://cdn.shopify.com/s/files/1/0263/0120/2516/articles/gerson-cifuentes-JNhaaPEz3FY-unsplash_800x.jpg?v=1576872775"), Product(name: "Espresso", price: 50, imageUrl: "https://media.istockphoto.com/photos/coffee-cup-picture-id1126871442?k=6&m=1126871442&s=612x612&w=0&h=LMKcuNjMACtiLKcz3Z1pzDdlULmatLZ1vkBNuOYYx88="), Product(name: "Latte", price: 60, imageUrl: "https://www.nespresso.com/ncp/res/uploads/recipes/nespresso-recipes-Latte-Art-Tulip.jpg"), Product(name: "Cappuccino", price: 60, imageUrl: "https://www.caffesociety.co.uk/assets/recipe-images/cappuccino-small.jpg"), Product(name: "Macchiato", price: 65, imageUrl: "https://i.pinimg.com/originals/2a/a6/25/2aa625d10f60e97a279abfe9c9e2b3b0.jpg")]
    let testProductDictOne: [String : Int] = ["Americano" : 2, "Latte" : 3, "Espresso" : 1]
    let uniqueProductListOne = [Product(name: "Americano", price: 45, imageUrl: "https://cdn.shopify.com/s/files/1/0263/0120/2516/articles/gerson-cifuentes-JNhaaPEz3FY-unsplash_800x.jpg?v=1576872775"), Product(name: "Espresso", price: 50, imageUrl: "https://media.istockphoto.com/photos/coffee-cup-picture-id1126871442?k=6&m=1126871442&s=612x612&w=0&h=LMKcuNjMACtiLKcz3Z1pzDdlULmatLZ1vkBNuOYYx88="), Product(name: "Latte", price: 60, imageUrl: "https://www.nespresso.com/ncp/res/uploads/recipes/nespresso-recipes-Latte-Art-Tulip.jpg")]
    let testProductDictTwo: [String : Int] = ["Macchiato" : 3, "Cappuccino" : 2]
    let uniqueProductListTwo = [Product(name: "Cappuccino", price: 60, imageUrl: "https://www.caffesociety.co.uk/assets/recipe-images/cappuccino-small.jpg"), Product(name: "Macchiato", price: 65, imageUrl: "https://i.pinimg.com/originals/2a/a6/25/2aa625d10f60e97a279abfe9c9e2b3b0.jpg")]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        networkManager = MockNetworkManager.shared
        model = OrderSummaryViewModel(products: expectedProductList, orderDict: testProductDictOne, networkManager: networkManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        model = nil
        networkManager = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testGenerateUniqueProductList() {
        model.generateUniqueProductList(orderDict: testProductDictOne)

        // Make test assertion(s).
        var uniqueProductsFromModel = model.uniqueProductsToOrder
        XCTAssertTrue(uniqueProductsFromModel.count == uniqueProductListOne.count)
        for (i, product) in uniqueProductListOne.enumerated() {
            XCTAssertTrue(product.name == uniqueProductsFromModel[i].name)
            XCTAssertTrue(product.imageUrl == uniqueProductsFromModel[i].imageUrl)
            XCTAssertTrue(product.price == uniqueProductsFromModel[i].price)
        }

        model = OrderSummaryViewModel(products: expectedProductList, orderDict: testProductDictTwo, networkManager: networkManager)
        model.generateUniqueProductList(orderDict: testProductDictTwo)

        // Make test assertion(s).
        uniqueProductsFromModel = model.uniqueProductsToOrder
        XCTAssertTrue(uniqueProductsFromModel.count == uniqueProductListTwo.count)
        for (i, product) in uniqueProductListTwo.enumerated() {
            XCTAssertTrue(product.name == uniqueProductsFromModel[i].name)
            XCTAssertTrue(product.imageUrl == uniqueProductsFromModel[i].imageUrl)
            XCTAssertTrue(product.price == uniqueProductsFromModel[i].price)
        }

        // Reset model to initial setting.
        model = OrderSummaryViewModel(products: expectedProductList, orderDict: testProductDictOne, networkManager: networkManager)
    }

    func testCalculatePrice() {
        var calculatedPrice = model.calculatePrice(products: uniqueProductListOne, orderDict: testProductDictOne)
        var expectedTotalPrice = 320

        // Make test assertion(s).
        XCTAssertTrue(calculatedPrice == expectedTotalPrice)

        model = OrderSummaryViewModel(products: expectedProductList, orderDict: testProductDictTwo, networkManager: networkManager)

        calculatedPrice = model.calculatePrice(products: uniqueProductListTwo, orderDict: testProductDictTwo)
        expectedTotalPrice = 315

        // Make test assertion(s).
        XCTAssertTrue(calculatedPrice == expectedTotalPrice)

        // Reset model to initial setting.
        model = OrderSummaryViewModel(products: expectedProductList, orderDict: testProductDictOne, networkManager: networkManager)
    }

    func testGetNumberOfItemsToOrder() {
        // Case 1.
        var calculatedNumberOfItems = model.getNumberOfItemsToOrder(productName: "Macchiato", orderDict: testProductDictOne)
        var expectedNumberOfItems = 0

        // Make test assertion(s).
        XCTAssertTrue(expectedNumberOfItems == expectedNumberOfItems)

        // Case 2.
        calculatedNumberOfItems = model.getNumberOfItemsToOrder(productName: "Latte", orderDict: testProductDictOne)
        expectedNumberOfItems = 3

        // Make test assertion(s).
        XCTAssertTrue(expectedNumberOfItems == expectedNumberOfItems)

        model = OrderSummaryViewModel(products: expectedProductList, orderDict: testProductDictTwo, networkManager: networkManager)

        // Case 3.
        calculatedNumberOfItems = model.getNumberOfItemsToOrder(productName: "Espresso", orderDict: testProductDictTwo)
        expectedNumberOfItems = 0

        // Make test assertion(s).
        XCTAssertTrue(calculatedNumberOfItems == expectedNumberOfItems)

        // Case 4.
        calculatedNumberOfItems = model.getNumberOfItemsToOrder(productName: "Cappuccino", orderDict: testProductDictTwo)
        expectedNumberOfItems = 2

        // Make test assertion(s).
        XCTAssertTrue(calculatedNumberOfItems == expectedNumberOfItems)

        // Reset model to initial setting.
        model = OrderSummaryViewModel(products: expectedProductList, orderDict: testProductDictOne, networkManager: networkManager)
    }

    func testPlaceOrder() {
        let expectation = expectation(description: "An order should be placed.")

        var isSuccessful = false
        var networkErrorMessage: String?
        model.placeOrder(address: "Some dummy address 1") { isSuccess, errorMessage in
            isSuccessful = isSuccess
            networkErrorMessage = errorMessage ?? ""
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)

        // Make test assertion(s)
        XCTAssertTrue(isSuccessful)
        XCTAssertTrue((networkErrorMessage ?? "").isEmpty)
    }

}
