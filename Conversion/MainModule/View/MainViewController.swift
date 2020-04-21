//
//  ViewController.swift
//  Conversion
//
//  Created by Александр Говорухин on 16.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import UIKit
import RxSwift

enum SelectedButton: Int {
    case fromButton = 0
    case toButton = 1
    
    func switchButton() -> SelectedButton {
        return self == .fromButton ? .toButton : .fromButton
    }
}

protocol MainViewProtocol: class {
    func showAlert(title: String, msg: String)
    func updateCurrency(selectedButton: SelectedButton, currency: Currency)
    func enabledTextFields(_ isEnabled: Bool)
    func setConvertingValue(button: SelectedButton, value: Double)
}

class MainViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet weak var fromCurrency: UIButton!
    @IBOutlet weak var fromTextField: CurrencyTextField!
    
    @IBOutlet weak var toCurrency: UIButton!
    @IBOutlet weak var toTextField: CurrencyTextField!
    
    var presenter: MainViewPresenterProtocol!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapDismissKeyboard()
        rxTextFields()
    }
    
    //MARK: IBAction
    @IBAction func didTapButton(_ sender: UIButton) {
        guard let selectedButton = SelectedButton(rawValue: sender.tag) else { return }
        presenter.goToChooseCurrencies(selectedButton)
    }
}

extension MainViewController: MainViewProtocol {
    func enabledTextFields(_ isEnabled: Bool) {
        let textFields = [fromTextField, toTextField]
        textFields.forEach {
            $0?.text = nil
            $0?.isEnabled = isEnabled
        }
    }
    
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let refresh = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.presenter.getRate()
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(refresh)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    func updateCurrency(selectedButton: SelectedButton, currency: Currency) {
        let symbol = currency.currencySymbol ?? ""
        let id = currency.id ?? ""
        switch selectedButton {
        case .fromButton:
            fromTextField.updateLabel(symbol)
            fromCurrency.setTitle(id, for: .normal)
        case .toButton:
            toTextField.updateLabel(symbol)
            toCurrency.setTitle(id, for: .normal)
        }
    }
    
    func setConvertingValue(button: SelectedButton, value: Double) {
        switch button {
        case .fromButton:
            fromTextField.updateLabel(value)
        case .toButton:
            toTextField.updateLabel(value)
        }
    }
}

extension MainViewController {
    private func rxTextFields() {
        disposeBag.insert([
            toTextField
                .rx.text
                .bind { [weak self] text in
                    self?.presenter.convertingCurrency(text, .toButton)
            },
            fromTextField
                .rx.text
                .bind { [weak self] text in
                    self?.presenter.convertingCurrency(text, .fromButton)
            }
        ])
    }
}
