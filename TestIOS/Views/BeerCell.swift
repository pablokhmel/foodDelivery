//
//  BeerCell.swift
//  TestIOS
//
//  Created by MacBook on 15.10.2022.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class BeerCell: UITableViewCell {
    static let identifier = "BeerCell"

    let disposeBag = DisposeBag()
    let beer = PublishSubject<Beer>()

    private lazy var beerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .white
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = Colors.description
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var buyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.type.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String("от 345 р"), for: .normal)
        button.setTitleColor(Colors.type, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        return button
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
        contentView.addSubview(beerImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(buyButton)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 180),

            beerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            beerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            beerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            beerImageView.widthAnchor.constraint(equalTo: beerImageView.heightAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: beerImageView.trailingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -16),

            buyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            buyButton.heightAnchor.constraint(equalToConstant: 32),
            buyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            buyButton.widthAnchor.constraint(equalToConstant: 87)
        ])
    }

    private func bindRx() {
        beer.subscribe(onNext: { value in
            self.titleLabel.rx.text.onNext(value.name)

            self.descriptionLabel.rx.text.onNext(value.description)

            let url = URL(string: value.image_url)
            self.beerImageView.sd_setImage(with: url)
        }).disposed(by: disposeBag)
    }
}
