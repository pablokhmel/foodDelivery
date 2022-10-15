//
//  ViewController.swift
//  TestIOS
//
//  Created by MacBook on 15.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

class MainVC: UIViewController {
    let disposeBag = DisposeBag()
    private let viewModel: MainVM

    private lazy var activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var beersTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(BeerCell.self, forCellReuseIdentifier: BeerCell.identifier)
        return view
    }()

    init(viewModel: MainVM) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupViews()
        bindRx()
        viewModel.getBeers()
    }

    private func setupViews() {
        view.addSubview(activityView)
        view.addSubview(beersTableView)

        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            beersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            beersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            beersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            beersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func bindRx() {
        viewModel.beers.subscribe(onNext: { value in
            self.activityView.stopAnimating()
            self.activityView.isHidden = true
            print(value.count)
        })
        .disposed(by: disposeBag)

        viewModel.beers.bind(to: beersTableView.rx.items(cellIdentifier: BeerCell.identifier, cellType: BeerCell.self))  { index, model, cell in
            cell.beer.onNext(model)
        }
        .disposed(by: disposeBag)
    }
}

