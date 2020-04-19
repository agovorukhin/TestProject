//
//  String+Extension.swift
//  Conversion
//
//  Created by Александр Говорухин on 18.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import Foundation

extension String {
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        let decimalSeparator = formatter.decimalSeparator ?? "."
        
        if formatter.number(from: self) != nil {
            let split = self.components(separatedBy: decimalSeparator)
            let digits = split.count == 2 ? split.last ?? "" : ""
            
            return digits.count <= maxDecimalPlaces
        }
        return false
    }
}
