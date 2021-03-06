//
//  OptionBoxView.swift
//  Autonomy
//
//  Created by Thuyen Truong on 3/26/20.
//  Copyright © 2020 Bitmark Inc. All rights reserved.
//

import UIKit
import SnapKit

class OptionBoxView: UIView {

    // MARK: - Properties
    lazy var titleLabel = makeTitleLabel()
    lazy var descriptionLabel = makeDescriptionLabel()
    lazy var button = makeButton()

    let title: String!
    let descriptionText: String!
    let titleTop: CGFloat!
    let descTop: CGFloat!
    let btnImage: UIImage!

    var attachedValue: Any?

    init(title: String, titleTop: CGFloat = 0, description: String, descTop: CGFloat = 4, btnImage: UIImage) {
        self.title = title
        self.titleTop = titleTop
        self.descriptionText = description
        self.descTop = descTop
        self.btnImage = btnImage

        super.init(frame: CGRect.zero)

        setupViews()
    }

    fileprivate func setupViews() {

        let leftView = LinearView(
            items: [
                (titleLabel, titleTop),
                (descriptionLabel, descTop)],
            bottomConstraint: true)

        addSubview(leftView)
        addSubview(button)

        leftView.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
        }

        button.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview()
        }

        snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(45)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OptionBoxView {
    fileprivate func makeTitleLabel() -> Label {
        let label = Label()
        label.apply(text: title,
                    font: R.font.atlasGroteskLight(size: Size.ds(24)),
                    themeStyle: .lightTextColor)
        return label
    }

    fileprivate func makeDescriptionLabel() -> Label {
        let label = Label()
        label.apply(text: descriptionText,
            font: R.font.atlasGroteskLight(size: 14),
            themeStyle: .silverChaliceColor, lineHeight: 1.2)
        label.numberOfLines = 0
        return label
    }

    fileprivate func makeButton() -> UIButton {
        let button = UIButton()
        button.setImage(btnImage, for: .normal)
        return button
    }
}
