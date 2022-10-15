//
//  BeerCell.swift
//  TestIOS
//
//  Created by MacBook on 15.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

class BeerCell: UITableViewCell {
    static let identifier = "BeerCell"

    let disposeBag = DisposeBag()
    let beer = PublishSubject<Beer>()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
        bindRx()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func bindRx() {
        beer.subscribe(onNext: { value in
            self.titleLabel.rx.text.onNext(String(value.id))
        }).disposed(by: disposeBag)
    }
}
