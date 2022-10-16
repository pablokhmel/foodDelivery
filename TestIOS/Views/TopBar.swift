//
//  TobBar.swift
//  TestIOS
//
//  Created by MacBook on 15.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

class TopBar: UIView {
    private let disposeBag = DisposeBag()

    let type = BehaviorSubject<AbvCategory?>(value: nil)
    let offset = BehaviorSubject(value: CGFloat(0))

    var discountHeightConstraint: NSLayoutConstraint?

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Москва"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var discountsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 112)
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(DiscountCell.self, forCellWithReuseIdentifier: DiscountCell.identifier)
        view.backgroundColor = .clear
        view.rx.setDelegate(self).disposed(by: disposeBag)
        return view
    }()

    private lazy var typeCollecitonView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 88, height: 32)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(TypeCell.self, forCellWithReuseIdentifier: TypeCell.identifier)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        setupViews()
        bindRx()
    }

    private func setupViews() {
        addSubview(cityLabel)
        addSubview(discountsCollectionView)
        addSubview(typeCollecitonView)

        discountHeightConstraint = NSLayoutConstraint(item: discountsCollectionView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: Constants.discountHeight)

        discountHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),

            discountsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            discountsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            discountsCollectionView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 12),

            typeCollecitonView.topAnchor.constraint(equalTo: discountsCollectionView.bottomAnchor, constant: 12),
            typeCollecitonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            typeCollecitonView.trailingAnchor.constraint(equalTo: trailingAnchor),
            typeCollecitonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            typeCollecitonView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func bindRx() {
        let discounts = ["discount", "discount"] // In full version I'll get them from backend and make models

        Observable.just(discounts).bind(to: discountsCollectionView.rx.items(cellIdentifier: DiscountCell.identifier)) {
            _,_,_ in
        }.disposed(by: disposeBag)

        let types = ["All", "Light", "Medium", "Hard"]

        Observable.just(types).bind(to: typeCollecitonView.rx.items(cellIdentifier: TypeCell.identifier, cellType: TypeCell.self)) { index, model, cell in
            cell.isCellSelected.onNext(index == 0)
            cell.title.onNext(model)
        }.disposed(by: disposeBag)

        typeCollecitonView
            .rx
            .itemSelected
            .subscribe(onNext: { index in
                self.typeCollecitonView.visibleCells.forEach { cell in
                    guard let cell = cell as? TypeCell else { return }
                    cell.isCellSelected.onNext(false)
                }

                let cell = self.typeCollecitonView.cellForItem(at: index) as? TypeCell
                cell?.isCellSelected.onNext(true)

                switch index.item {
                case 1: self.type.onNext(.light)

                case 2: self.type.onNext(.medium)

                case 3: self.type.onNext(.hard)

                default: self.type.onNext(nil)
                }
            })
            .disposed(by: disposeBag)

        offset.bind { value in
            self.updateConstraints(for: value)
        }.disposed(by: disposeBag)
    }

    private func updateConstraints(for offset: CGFloat) {
        guard offset >= 0 else { return }

        discountHeightConstraint?.constant = max(Constants.discountHeight - offset, 0)

        discountsCollectionView.alpha = max(0, (1 - offset / (Constants.discountHeight - 24)))
        layoutIfNeeded()
        discountsCollectionView.reloadData()
    }
}

private enum Constants {
    static let discountHeight: CGFloat = 136
}

extension TopBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("yes")
        let height = max(collectionView.frame.height - 24, 0)
        let width = height / (Constants.discountHeight - 24) * 300
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}
