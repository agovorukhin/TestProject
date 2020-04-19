//
//  RouterTest.swift
//  ConversionTests
//
//  Created by Александр Говорухин on 16.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import XCTest
@testable import Conversion

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: true)
    }
}

class RouterTest: XCTestCase {
    var router: RouterProtocol!
    let navigationController = MockNavigationController()
    let builder = Builder()
    
    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, builder: builder)
    }

    override func tearDownWithError() throws {
        router = nil
    }
    
    func testRouter() {
        router.showCurrencies(completion: nil)
        let currenciesVC = navigationController.presentedVC
        XCTAssertTrue(currenciesVC is CurrenciesViewController)
    }
}
