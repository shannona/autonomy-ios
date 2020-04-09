//
//  HealthScoreCollectionCell.swift
//  Autonomy
//
//  Created by Thuyen Truong on 4/8/20.
//  Copyright © 2020 Bitmark Inc. All rights reserved.
//

import UIKit
import RxSwift

class HealthScoreCollectionCell: UICollectionViewCell {

    // MARK: - Properties
    lazy var healthView = makeHealthView()
    lazy var guideView = makeGuideView()
    lazy var guideDataView = makeGuideDataView()
    lazy var behaviorGuideView = makeBehaviorGuideView()

    // Behavior Guide View
    lazy var riskLabel = makeRiskLabel()
    lazy var behaviorLabel = makeBehaviorLabel()

    // Data Guide View
    lazy var confirmedCasesView = ScoreInfoView(scoreInfoType: .confirmedCases)
    lazy var reportedSymptomsView = ScoreInfoView(scoreInfoType: .reportedSymptoms)
    lazy var healthyBehaviorsView = ScoreInfoView(scoreInfoType: .healthyBehaviors)
    lazy var populationDensityView = ScoreInfoView(scoreInfoType: .populationDensity)

    fileprivate let disposeBag = DisposeBag()

    override func layoutSubviews() {
        super.layoutSubviews()

        setupViews()
    }

    fileprivate func setupViews() {
        contentView.addSubview(healthView)
        contentView.addSubview(guideView)

        healthView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Size.dh(70))
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(HealthScoreTriangle.originalSize.height * HealthScoreTriangle.scale)
        }

        guideView.snp.makeConstraints { (make) in
            make.top.equalTo(healthView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(210)
        }
    }

    func setData() {
        riskLabel.setText("LOW RISK")
        behaviorLabel.setText("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco.")
    }
}

extension HealthScoreCollectionCell {
    fileprivate func makeHealthView() -> UIView {
        let emptyTriangle = makeHealthScoreView(score: nil)

        let view = UIView()
        view.addSubview(emptyTriangle)
        emptyTriangle.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        return view
    }

    fileprivate func makeHealthScoreView(score: Int?) -> UIView {
        let healthScoreTriangle = HealthScoreTriangle(score: score)

        let appNameLabel = Label()
        appNameLabel.apply(text: Constant.appName.localizedUppercase,
                    font: R.font.domaineSansTextLight(size: 18),
                    themeStyle: .lightTextColor)

        let scoreLabel = Label()


        let view = UIView()
        view.addSubview(healthScoreTriangle)
        view.addSubview(appNameLabel)


        healthScoreTriangle.snp.makeConstraints { (make) in
            make.edges.centerX.equalToSuperview()
        }

        appNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(healthScoreTriangle).offset(-40 * HealthScoreTriangle.scale)
        }

        if let score = score {
            scoreLabel.apply(
                text: "\(score)",
                font: R.font.domaineSansTextLight(size: 64),
                themeStyle: .lightTextColor)

            view.addSubview(scoreLabel)
            scoreLabel.snp.makeConstraints { (make) in
                make.bottom.equalTo(appNameLabel.snp.top).offset(10)
                make.centerX.equalToSuperview()
            }
        }

        return view
    }

    fileprivate func makeGuideView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#828180")
        view.addSubview(behaviorGuideView)
        view.addSubview(guideDataView)

        guideDataView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
                .inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }

        behaviorGuideView.snp.makeConstraints { (make) in
            make.edges.equalTo(guideDataView)
        }

        guideDataView.isHidden = true
        return view
    }

    fileprivate func makeBehaviorGuideView() -> UIView {
        let flipButton = UIButton()
        flipButton.setImage(R.image.crossArrow(), for: .normal)

        let contentView = LinearView(
            items: [(riskLabel, 0), (behaviorLabel, 15)],
            bottomConstraint: true)

        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(contentView)
        view.addSubview(flipButton)

        flipButton.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview()
        }

        contentView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }

        defer {
            flipButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                self.flip(fromView: self.behaviorGuideView, toView: self.guideDataView)
            }.disposed(by: disposeBag)
        }

        return view
    }

    fileprivate func makeGuideDataView() -> UIView {
        let flipButton = UIButton()
        flipButton.setImage(R.image.crossArrow(), for: .normal)

        let rawDataTitle = Label()
        rawDataTitle.apply(
            text: R.string.localizable.rawData().localizedUppercase,
            font: R.font.domaineSansTextLight(size: Size.ds(18)),
            themeStyle: .lightTextColor)

        let fromLast24Hours = Label()
        fromLast24Hours.apply(
            text: R.string.localizable.from_last_24_hours(),
            font: R.font.atlasGroteskLight(size: Size.ds(13)),
            themeStyle: .silverTextColor)

        let titleView = UIView()
        titleView.addSubview(rawDataTitle)
        titleView.addSubview(fromLast24Hours)

        rawDataTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-4)
            make.leading.bottom.equalToSuperview()
        }

        fromLast24Hours.snp.makeConstraints { (make) in
            make.leading.equalTo(rawDataTitle.snp.trailing).offset(12)
            make.top.equalToSuperview()
        }

        let row1 = makeScoreInfosRow(view1: confirmedCasesView, view2: reportedSymptomsView)
        let row2 = makeScoreInfosRow(view1: healthyBehaviorsView, view2: populationDensityView)

        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(titleView)
        view.addSubview(row1)
        view.addSubview(row2)
        view.addSubview(flipButton)

        titleView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }

        row1.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(Size.dh(26))
            make.leading.trailing.equalToSuperview()
        }

        row2.snp.makeConstraints { (make) in
            make.top.equalTo(row1.snp.bottom).offset(Size.dh(15))
            make.leading.trailing.equalToSuperview()
        }

        flipButton.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview()
        }

        defer {
            flipButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                self.flip(fromView: self.guideDataView, toView: self.behaviorGuideView)
            }.disposed(by: disposeBag)
        }

        return view
    }

    fileprivate func makeScoreInfosRow(view1: UIView, view2: UIView) -> UIView {
        let view = UIView()
        view.addSubview(view1)
        view.addSubview(view2)

        view1.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5).offset(Size.dw(15) / 2)
        }

        view2.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(view1.snp.trailing).offset(Size.dw(15))
            make.width.equalTo(view1)
        }

        return view
    }

    fileprivate func flip(fromView: UIView, toView: UIView) {
        UIView.transition(with: toView, duration: 0.5, options: .transitionFlipFromTop, animations: {
            fromView.isHidden = true
            toView.isHidden = false
        })
    }

    fileprivate func makeRiskLabel() -> Label {
        let label = Label()
        label.apply(font: R.font.domaineSansTextLight(size: 18), themeStyle: .lightTextColor)
        return label
    }

    fileprivate func makeBehaviorLabel() -> Label {
        let label = Label()
        label.numberOfLines = 0
        label.apply(font: R.font.atlasGroteskLight(size: 16), themeStyle: .lightTextColor)
        return label
    }
}
