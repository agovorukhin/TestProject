//
//  UIViewController+Extension.swift
//  Conversion
//
//  Created by Александр Говорухин on 17.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import UIKit

extension UIViewController {
    func tapDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
