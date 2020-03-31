//
//  CheckboxView.swift
//  Autonomy
//
//  Created by Thuyen Truong on 3/26/20.
//  Copyright © 2020 Bitmark Inc. All rights reserved.
//

import UIKit
import SnapKit
import BEMCheckBox
import RxSwift

class CheckboxView: UIView {

    // MARK: - Properties
    lazy var checkBox = makeCheckBox()
    lazy var titleLabel = makeTitleLabel()
    lazy var descLabel = makeDescLabel()
    var title: String! {
        didSet {
            titleLabel.setText(title)
        }
    }
    var desc: String? {
        didSet {
            descLabel.setText(desc)
        }
    }

    fileprivate lazy var tapGestureRecognizer = makeTapGestureRecognizer()
    let disposeBag = DisposeBag()

    init(title: String?, description: String? = nil) {
        self.title = title
        self.desc = description

        super.init(frame: CGRect.zero)

        setupViews()
    }

    fileprivate func setupViews() {
        isSkeletonable = true

        let textView: UIView!
        if desc != nil {
            textView = LinearView(items: [(titleLabel, 0), (descLabel, 3)])
            titleLabel.isSkeletonable = true
            descLabel.isSkeletonable = true
        } else {
            textView = titleLabel
        }

        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(tapGestureRecognizer)
        addSubview(checkBox)
        addSubview(textView)

        checkBox.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.width.height.equalTo(45)
        }

        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(checkBox.snp.trailing).offset(15)
            make.top.trailing.bottom.equalToSuperview()
        }

        // setup isSkeletonable
        isSkeletonable = true
        checkBox.isSkeletonable = true
        textView.isSkeletonable = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckboxView {
    fileprivate func makeCheckBox() -> BEMCheckBox {
        let checkBox = BEMCheckBox()
        checkBox.tintColor = .white
        checkBox.lineWidth = 1
        checkBox.onCheckColor = .white
        checkBox.onTintColor = .white
        checkBox.animationDuration = 0.2
        checkBox.onAnimationType = .bounce
        checkBox.offAnimationType = .bounce
        return checkBox
    }

    fileprivate func makeTitleLabel() -> Label {
        let label = Label()
        label.apply(text: title,
                    font: R.font.atlasGroteskLight(size: 24),
                    themeStyle: .lightTextColor)
        return label
    }

    fileprivate func makeDescLabel() -> Label {
        let label = Label()
        label.numberOfLines = 0
        label.apply(text: desc,
                    font: R.font.atlasGroteskLight(size: 14),
                    themeStyle: .silverTextColor,
                    lineHeight: 1.2)
        return label
    }

    fileprivate func makeTapGestureRecognizer() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.rx.event.bind { [weak checkBox] (_) in
            guard let checkBox = checkBox else { return }
            checkBox.on = !checkBox.on
            checkBox.setOn(checkBox.on, animated: true)
            checkBox.delegate?.didTap?(checkBox)

        }.disposed(by: disposeBag)
        return tapGestureRecognizer
    }
}