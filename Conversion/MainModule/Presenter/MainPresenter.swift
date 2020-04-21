//
//  MainPresenter.swift
//  Conversion
//
//  Created by Александр Говорухин on 16.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol)
    func goToChooseCurrencies(_ button: SelectedButton)
    func convertingCurrency(_ value: String?, _ button: SelectedButton)
    func getRate()
    var converting: CurrencyPair { get }
}

class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    var router: RouterProtocol!
    var converting = CurrencyPair()
    let networkService: NetworkServiceProtocol!
    let disposeBag = DisposeBag()
    
    required init(view: MainViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        subscribe()
    }
    
    func subscribe() {
        disposeBag.insert([
            converting.currPairChange
            .bind { [weak self] change in
                if change {
                    self?.getRate()
                }
                DispatchQueue.main.async {
                    self?.view?.enabledTextFields(change)
                }
            }
        ])
    }
    
    func goToChooseCurrencies(_ button: SelectedButton) {
        router.showCurrencies(completion: { [weak self] curr in
            switch button {
            case .fromButton:
                self?.converting.transferFrom.accept(curr)
            case .toButton:
                self?.converting.transferTo.accept(curr)
            }
            self?.view?.updateCurrency(selectedButton: button, currency: curr)
        })
    }
    
    func convertingCurrency(_ value: String?, _ button: SelectedButton) {
        guard let rate = converting.ratePair else { return }
        var result = Double(value ?? "") ?? 0
        switch button {
        case .fromButton:
            result *= rate
        case .toButton:
            result /= rate
        }
        view?.setConvertingValue(button: button.switchButton(), value: result)
    }
    
    func getRate() {
        guard let currPair = converting.currPair else { return }
        networkService.getRate(currPair, completion: { [weak self] result in
            switch result {
            case .success(let value):
                self?.converting.ratePair = value
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.showAlert(title: "Ошибка", msg: error.localizedDescription)
                }
            }
        })
    }
}
