//
//  MainVM.swift
//  TestIOS
//
//  Created by MacBook on 15.10.2022.
//

import Foundation
import RxSwift

class MainVM {
    public private(set) var beers = BehaviorSubject(value: [Beer]())

    public func getBeers() {
        apiProvider.request(.beers) { [weak self] result in
            switch result {
            case .success(let response):
                guard let tokenResponse = try? response.map([Beer].self) else { return }
                self?.addBeers(tokenResponse)

            case .failure(let error):
                print(error)
            }
        }
    }

    private func addBeers(_ new: [Beer]) {
        guard var value = try? beers.value() else { return }

        value.append(contentsOf: new)
        beers.onNext(value)
    }
}
