//
//  DirectionModel.swift
//  Conversion
//
//  Created by Александр Говорухин on 17.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct CurrencyPair {
    var transferFrom = BehaviorRelay<Currency?>(value: nil)
    var transferTo = BehaviorRelay<Currency?>(value: nil)
    var ratePair: Double?
    var currPair: String? {
        guard
            let from = transferFrom.value?.id,
            let to = transferTo.value?.id
        else { return nil }
        return from + "_" + to
    }
    var currPairChange: Observable<Bool> {
        return Observable.combineLatest(transferFrom, transferTo) {
            return $0 != nil && $1 != nil
        }
    }
}
