//
//  Currency.swift
//  Conversion
//
//  Created by Александр Говорухин on 16.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import Foundation

struct Response: Decodable {
    let results: [String: Currency]
}

struct Currency: Decodable {
    let currencyName: String?
    let currencySymbol: String?
    let id: String?
}
