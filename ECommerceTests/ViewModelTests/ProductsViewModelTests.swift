//
//  ProductsViewModelTests.swift
//  ECommerceTests
//
//  Created by Tashreque Mohammed Haq on 11/10/21.
//

import XCTest
@testable import ECommerce

class ProductsViewModelTests: XCTestCase {

    var networkManager: MockNetworkManager!
    var model: ProductsViewModel!
    let expectedProductList = [Product(name: "Americano", price: 45, imageUrl: "https://cdn.shopify.com/s/files/1/0263/0120/2516/articles/gerson-cifuentes-JNhaaPEz3FY-unsplash_800x.jpg?v=1576872775"), Product(name: "Espresso", price: 50, imageUrl: "https://media.istockphoto.com/photos/coffee-cup-picture-id1126871442?k=6&m=1126871442&s=612x612&w=0&h=LMKcuNjMACtiLKcz3Z1pzDdlULmatLZ1vkBNuOYYx88="), Product(name: "Latte", price: 60, imageUrl: "https://www.nespresso.com/ncp/res/uploads/recipes/nespresso-recipes-Latte-Art-Tulip.jpg"), Product(name: "Cappuccino", price: 60, imageUrl: "https://www.caffesociety.co.uk/assets/recipe-images/cappuccino-small.jpg"), Product(name: "Macchiato", price: 65, imageUrl: "https://i.pinimg.com/originals/2a/a6/25/2aa625d10f60e97a279abfe9c9e2b3b0.jpg")]
    let expectedStoreInfo = StoreInfo(name: "The Coffee Shop", rating: 4.5, openingTime: "10:00", closingTime: "20:00")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        networkManager = MockNetworkManager.shared
        model = ProductsViewModel(networkManager: networkManager)
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

    func testRetrieveAllInformation() {
        let expectation = expectation(description: "Fetch store information and product list")

        model.retrieveAllInformation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)

        // Make test assertion(s).
        let productsFromModel = model.products
        let storeInfoFromModel = model.storeInformation
        XCTAssertTrue(productsFromModel.count == expectedProductList.count)
        for (i, product) in expectedProductList.enumerated() {
            XCTAssertTrue(product.name == productsFromModel[i].name)
            XCTAssertTrue(product.imageUrl == productsFromModel[i].imageUrl)
            XCTAssertTrue(product.price == productsFromModel[i].price)
        }
        XCTAssertTrue(storeInfoFromModel?.name == expectedStoreInfo.name)
        XCTAssertTrue(storeInfoFromModel?.rating == expectedStoreInfo.rating)
        XCTAssertTrue(storeInfoFromModel?.openingTime == expectedStoreInfo.openingTime)
        XCTAssertTrue(storeInfoFromModel?.closingTime == expectedStoreInfo.closingTime)
    }

    func testGetStoreInformation() {
        let expectation = expectation(description: "Fetch store information only")
        var retrievedStoreInfo: StoreInfo?

        model.getStoreInformation { storeInfo, errorMessage in
            retrievedStoreInfo = storeInfo
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)

        // Make test assertion(s).
        let storeInfoFromModel = model.storeInformation

        XCTAssertTrue(retrievedStoreInfo?.name == expectedStoreInfo.name)
        XCTAssertTrue(retrievedStoreInfo?.rating == expectedStoreInfo.rating)
        XCTAssertTrue(retrievedStoreInfo?.openingTime == expectedStoreInfo.openingTime)
        XCTAssertTrue(retrievedStoreInfo?.closingTime == expectedStoreInfo.closingTime)

        XCTAssertTrue(storeInfoFromModel?.name == expectedStoreInfo.name)
        XCTAssertTrue(storeInfoFromModel?.rating == expectedStoreInfo.rating)
        XCTAssertTrue(storeInfoFromModel?.openingTime == expectedStoreInfo.openingTime)
        XCTAssertTrue(storeInfoFromModel?.closingTime == expectedStoreInfo.closingTime)
    }

    func testGetProductList() {
        let expectation = expectation(description: "Fetch store information only")
        var retrievedProducts: [Product]?

        model.getProductList { products, erroMessage in
            retrievedProducts = products
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)

        // Make test assertion(s).
        let productsFromModel = model.products
        XCTAssertTrue(retrievedProducts?.count == expectedProductList.count)
        for (i, product) in expectedProductList.enumerated() {
            XCTAssertTrue(product.name == retrievedProducts?[i].name)
            XCTAssertTrue(product.imageUrl == retrievedProducts?[i].imageUrl)
            XCTAssertTrue(product.price == retrievedProducts?[i].price)
        }

        XCTAssertTrue(productsFromModel.count == expectedProductList.count)
        for (i, product) in expectedProductList.enumerated() {
            XCTAssertTrue(product.name == productsFromModel[i].name)
            XCTAssertTrue(product.imageUrl == productsFromModel[i].imageUrl)
            XCTAssertTrue(product.price == productsFromModel[i].price)
        }
    }

}
