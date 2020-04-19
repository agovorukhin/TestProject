//
//  ModuleBuilder.swift
//  Conversion
//
//  Created by Александр Говорухин on 16.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import UIKit

protocol BuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createCurrenciesModule(router: RouterProtocol, completion: ((Currency) -> Void)?) -> UIViewController
}

class Builder: BuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkServices = NetworkService()
        let presenter = MainPresenter(view: view, router: router, networkService: networkServices)
        view.presenter = presenter
        return view
    }
    
    func createCurrenciesModule(router: RouterProtocol, completion: ((Currency) -> Void)?) -> UIViewController {
        let view = CurrenciesViewController()
        let networkServices = NetworkService()
        let presenter = CurrenciesPresenter(view: view, router: router, networkService: networkServices)
        presenter.completion = completion
        view.presenter = presenter
        return view
    }
}
