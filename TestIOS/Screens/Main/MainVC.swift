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

    private lazy var topBar: TopBar = {
        let view = TopBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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

        view.backgroundColor = Colors.background
        setupViews()
        bindRx()
        viewModel.getBeers()
    }

    private func setupViews() {
        view.addSubview(topBar)
        view.addSubview(activityView)
        view.addSubview(beersTableView)

        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            beersTableView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
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

        topBar.type.subscribe(onNext: { value in
            self.viewModel.type.onNext(value)
        }).disposed(by: disposeBag)

        beersTableView
            .rx
            .didScroll
            .bind {
            let offset = self.beersTableView.contentOffset.y
            self.topBar.offset.onNext(offset)
        }
            .disposed(by: disposeBag)

        viewModel.noInternet.bind { value in
            if value {
                self.showNoInternetError()
            }
        }.disposed(by: disposeBag)
    }

    private func showNoInternetError() {
        let alert = UIAlertController(title: "Error", message: "There is error. We loaded items from last connection", preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(action)

        present(alert, animated: true)
    }
}

