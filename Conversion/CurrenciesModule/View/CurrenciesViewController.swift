//
//  CurrenciesViewController.swift
//  Conversion
//
//  Created by Александр Говорухин on 16.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CurrenciesViewProtocol: class {
    var activityIndicator: UIActivityIndicatorView! { get set }
    func showAlert(title: String, msg: String)
}

class CurrenciesViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: CurrenciesPresenterProtocol!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didSelectRow()
        rxSearchBar()
        subscribe()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func subscribe() {
        presenter.currencies
            .bind { [weak self] value in
                if value.isEmpty {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
        }.disposed(by: disposeBag)
    }
}

extension CurrenciesViewController {
    func rxSearchBar() {
        let results = searchBar.rx.text.orEmpty
          .distinctUntilChanged()
          .flatMapLatest { [weak self] query -> Observable<[Currency]> in
            guard let self = self else { return .just([]) }
            if query.isEmpty {
                return self.presenter.currencies.asObservable()
            }
            return self.presenter.searchCurrency(query)
          }

        results
          .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { _, model, cell in
              cell.textLabel?.text = model.currencyName
          }.disposed(by: disposeBag)
    }
    
    func didSelectRow() {
        tableView
            .rx.modelSelected(Currency.self)
            .subscribe(onNext: { [weak self] value in
                self?.presenter.chooseCurrency(currency: value)
            })
            .disposed(by: disposeBag)
    }
}

extension CurrenciesViewController: CurrenciesViewProtocol {
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let refresh = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.presenter.getCurrencies()
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(refresh)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
