//
//  CurrenciesViewPresenter.swift
//  Conversion
//
//  Created by Александр Говорухин on 16.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CurrenciesPresenterProtocol: AnyObject {
    init(view: CurrenciesViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol)
    func chooseCurrency(currency: Currency)
    func searchCurrency(_ search: String) -> Observable<[Currency]>
    func getCurrencies()
    var currencies: BehaviorRelay<[Currency]> { get }
}

class CurrenciesPresenter: CurrenciesPresenterProtocol {
    weak var view: CurrenciesViewProtocol?
    var router: RouterProtocol?
    var currencies = BehaviorRelay<[Currency]>(value: [])
    var completion: ((Currency) -> Void)?
    
    let networkService: NetworkServiceProtocol!
    
    required init(view: CurrenciesViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        getCurrencies()
    }
    
    func searchCurrency(_ search: String) -> Observable<[Currency]> {
        let filter = currencies.value.filter { ($0.currencyName?.hasPrefix(search) ?? false) }
        return Observable.just(filter)
    }
    
    func chooseCurrency(currency: Currency) {
        completion?(currency)
        router?.popToRoot()
    }
    
    func getCurrencies() {
        networkService.getCurrencies { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let currencies):
                    self.currencies.accept(currencies)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.view?.activityIndicator.stopAnimating()
                        self.view?.showAlert(title: "Ошибка", msg: error.localizedDescription)
                    }
                }
            }   
        }
    }
    
}
