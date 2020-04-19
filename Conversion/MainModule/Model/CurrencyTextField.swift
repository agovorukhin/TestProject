//
//  CurrencyTextField.swift
//  Conversion
//
//  Created by Александр Говорухин on 18.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import UIKit

class CurrencyTextField: UITextField {
    
    var symbolLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
        delegate = self
    }
    
    func updateLabel(_ symbol: String) {
        symbolLabel.text = symbol
    }
    
    func updateLabel(_ value: Double) {
        self.text = String(format: "%.2f", value)
    }
    
    private func setupTextField() {
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: self.frame.width / 4,
                                        height: self.frame.height))
        symbolLabel = UILabel(frame: view.frame)
        symbolLabel.textAlignment = .center
        view.addSubview(symbolLabel)
        rightView = view
        rightViewMode = .always
    }
}

extension CurrencyTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else { return true }
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return replacementText.isValidDouble(maxDecimalPlaces: 2)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        text = String(format: "%.2f", Double(textField.text ?? "") ?? 0.0)
    }
}
