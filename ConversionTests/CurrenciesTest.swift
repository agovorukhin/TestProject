//
//  ConversionTests.swift
//  ConversionTests
//
//  Created by Александр Говорухин on 16.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import XCTest
@testable import Conversion

class MockCurrenciesView: CurrenciesViewProtocol {
    func success() {
        
    }
    
    func failure(_ error: Error) {
        
    }
}

class CurrenciesPresenterTest: XCTestCase {
    var view: MockCurrenciesView!
    var presenter: CurrenciesPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    var currencies = [Currency]()
    
    override func setUp() {
        let nav = UINavigationController()
        let builder = Builder()
        router = Router(navigationController: nav, builder: builder)
    }
    
    override func tearDown() {
        view = nil
        networkService = nil
        presenter = nil
    }
    
    func testGetSuccessCurrencies() {
        let currency = Currency(currencyName: "Рубль", currencySymbol: "Р", id: "1")
        currencies.append(currency)
        
        view = MockCurrenciesView()
        networkService = MockNetworkServices(currencies: currencies)
        presenter = CurrenciesPresenter(view: view, router: router, networkService: networkService)
        
        var catchCurrencies: [Currency]?
        
        networkService.getCurrencies { result in
            switch result {
            case .success(let currencies):
                catchCurrencies = currencies
            case .failure(let error):
                print(error)
            }
        }
        
        XCTAssertNotEqual(catchCurrencies?.count, 0)
        XCTAssertEqual(catchCurrencies?.count, currencies.count)
    }
    
    func testGetFailureCurrencies() {
        view = MockCurrenciesView()
        networkService = MockNetworkServices()
        presenter = CurrenciesPresenter(view: view, router: router, networkService: networkService)
        
        var catchError: Error?
        
        networkService.getCurrencies { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                catchError = error
            }
        }
        
        XCTAssertNotNil(catchError)
    }
}
