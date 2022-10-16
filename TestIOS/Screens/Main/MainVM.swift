//
//  MainVM.swift
//  TestIOS
//
//  Created by MacBook on 15.10.2022.
//

import Foundation
import RxSwift

class MainVM {
    private let disposeBag = DisposeBag()

    public private(set) var beers = BehaviorSubject(value: [Beer]())
    private var allBeers = BehaviorSubject(value: [Beer]())

    public let type = BehaviorSubject<AbvCategory?>(value: nil)

    init() {
        bindRx()
    }

    private func bindRx() {
        allBeers.subscribe(onNext: { _ in
            self.filterBeers()
        }).disposed(by: disposeBag)

        type.subscribe(onNext: { _ in
            self.filterBeers()
        }).disposed(by: disposeBag)
    }

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
        guard var value = try? allBeers.value() else { return }

        value.append(contentsOf: new)
        allBeers.onNext(value)
    }

    private func filterBeers() {
        guard let value = try? allBeers.value() else { return }

        if let type = try? type.value() {
            let filtered = value.filter { $0.abv == type }
            beers.onNext(filtered)
        } else {
            beers.onNext(value)
        }
    }
}
