//
//  MockNetworkService.swift
//  ConversionTests
//
//  Created by Александр Говорухин on 19.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import Foundation
@testable import Conversion

class MockNetworkServices: NetworkServiceProtocol {
    var currencies: [Currency]!

    init() {}
    
    convenience init(currencies: [Currency]?) {
        self.init()
        self.currencies = currencies
    }
    
    func getCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void) {
        if let currencies = currencies {
            completion(.success(currencies))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
    
    func getRate(_ currPair: String, completion: @escaping (Result<Double, Error>) -> Void) {
        if let path = Bundle.main.path(forResource: "JSONConvert", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: [])
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Double]
                if let value = json?.values.first {
                    completion(.success(value))
                }
            } catch {
                let error = NSError(domain: "Error", code: 1, userInfo: nil)
                completion(.failure(error))
            }
        }
    }
}
