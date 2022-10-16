//
//  TypeCell.swift
//  TestIOS
//
//  Created by MacBook on 15.10.2022.
//

import UIKit
import RxSwift

class TypeCell: UICollectionViewCell {
    static let identifier = "TypeCell"

    let disposeBag = DisposeBag()
    let isCellSelected = BehaviorSubject(value: false)
    let title = PublishSubject<String>()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.type.withAlphaComponent(0.4)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = Colors.type.withAlphaComponent(0.4).cgColor
        contentView.layer.cornerRadius = 16
        
        setupViews()
        bindRx()
    }

    private func setupViews() {
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func bindRx() {
        isCellSelected.bind { value in
            if value {
                self.contentView.backgroundColor = Colors.type.withAlphaComponent(0.4)
                self.titleLabel.textColor = Colors.type
                self.titleLabel.font = .systemFont(ofSize: 13, weight: .bold)
            } else {
                self.contentView.backgroundColor = .clear
                self.titleLabel.textColor = Colors.type.withAlphaComponent(0.4)
                self.titleLabel.font = .systemFont(ofSize: 13, weight: .bold)
            }
        }.disposed(by: disposeBag)

        title.bind { value in
            self.titleLabel.rx.text.onNext(value)
        }.disposed(by: disposeBag)
    }
}
