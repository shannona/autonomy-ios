//
//  AutonomyTrendingViewController.swift
//  Autonomy
//
//  Created by Thuyen Truong on 6/9/20.
//  Copyright © 2020 Bitmark Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftRichString

class AutonomyTrendingViewController: ViewController, BackNavigator {

    // MARK: - Properties
    fileprivate lazy var scrollView = makeScrollView()
    fileprivate lazy var headerScreen: UIView = { HeaderView(header: "AUTONOMY") }()
    fileprivate lazy var timelineView = TimeFilterView()
    fileprivate lazy var dataStackView = makeDataStackView()
    fileprivate lazy var casesScoreDataView = HealthDataRow(info: R.string.localizable.casesScore().localizedUppercase, hasDot: true)
    fileprivate lazy var symptomsScoreDataView = HealthDataRow(info: R.string.localizable.symptomsScore().localizedUppercase, hasDot: true)
    fileprivate lazy var behaviorsScoreDataView = HealthDataRow(info: R.string.localizable.behaviorsScore().localizedUppercase, hasDot: true)

    fileprivate lazy var backButton = makeLightBackItem()
    fileprivate lazy var jupyterButton = makeViewOnJupyterButton()
    fileprivate lazy var groupsButton: UIView = {
        let groupView = ButtonGroupView(button1: backButton, button2: jupyterButton, hasGradient: false)
        groupView.apply(backgroundStyle: .codGrayBackground)
        return groupView
    }()
    fileprivate lazy var loadIndicator = makeLoadIndicator()

    fileprivate lazy var thisViewModel: AutonomyTrendingViewModel = {
        return viewModel as! AutonomyTrendingViewModel
    }()

    override func bindViewModel() {
        super.bindViewModel()

        timelineView.datePeriodRelay
            .filterNil()
            .subscribe(onNext: { [weak self] in
                self?.thisViewModel.fetchTrending(in: $0)
            })
            .disposed(by: disposeBag)

        thisViewModel.reportItemsRelay
            .filterNil()
            .subscribe(onNext: { [weak self] (reportItems) in
                self?.rebuildScoreView(with: reportItems)
            })
            .disposed(by: disposeBag)
    }

    override func setupViews() {
        super.setupViews()

        // *** Setup subviews ***
        let paddingContentView = LinearView(
            items: [
                (headerScreen, 0),
                (timelineView, 10),
                (makeGraphsComingSoonView(), 0),
                (SeparateLine(height: 1), 0),
                (dataStackView, Size.dh(74)),
                (SeparateLine(height: 1), Size.dh(45)),
                (makeSourceInfoView(), Size.dh(44))
            ], bottomConstraint: true)

        scrollView.addSubview(paddingContentView)
        paddingContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview().offset(-30)
        }

        paddingContentView.addSubview(loadIndicator)
        loadIndicator.snp.makeConstraints { (make) in
            make.top.equalTo(timelineView.snp.bottom).offset(15)
            make.leading.equalToSuperview()
        }

        contentView.addSubview(scrollView)
        contentView.addSubview(groupsButton)

        scrollView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(groupsButton.snp.top).offset(-5)
        }

        groupsButton.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    fileprivate func rebuildScoreView(with reportItems: [ReportItem]) {
        dataStackView.removeArrangedSubviews()
        dataStackView.removeSubviews()

        guard let reportItem = reportItems.first else { return }

        let healthDataRow = HealthDataRow(info: reportItem.name.localizedUppercase, hasDot: true)
        healthDataRow.setData(autonomyReportItem: reportItem)

        dataStackView.addArrangedSubview(healthDataRow)
    }
}

// MARK: - UITextViewDelegate, Navigator
extension AutonomyTrendingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        navigator.show(segue: .safariController(URL), sender: self, transition: .alert)
        return false
    }

    func moveToJupyterNotebook() {
        guard let jupyterURL = AppLink.formulaJupyter.websiteURL else { return }
        navigator.show(segue: .safariController(jupyterURL), sender: self, transition: .alert)
    }
}

// MARK: - Setup views
extension AutonomyTrendingViewController {
    fileprivate func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 14, left: 15, bottom: 25, right: 15)
        return scrollView
    }

    fileprivate func makeGraphsComingSoonView() -> UIView {
        let label = Label()
        label.textAlignment = .center
        label.apply(text: R.string.localizable.graphs_coming_soon(),
                    font: R.font.atlasGroteskLight(size: 18),
                    themeStyle: .concordColor, lineHeight: 1.25)

        let view = UIView()
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
                .inset(UIEdgeInsets(top: Size.dh(106), left: 0, bottom: Size.dh(106), right: 0))
        }

        return view
    }

    fileprivate func makeDataStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [], axis: .vertical, spacing: 15)
    }

    fileprivate func makeSourceInfoView() -> UIView {
        let title = makeSourceInfoTitleLabel()
        let textView = makeSourceInfoTextView()

        let view = UIView()
        view.addSubview(title)
        view.addSubview(textView)

        title.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }

        textView.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(-5)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
        return view
    }

    fileprivate func makeSourceInfoTitleLabel() -> Label {
        let label = Label()
        label.numberOfLines = 0
        label.apply(text: R.string.phrase.sourceInfoTitle().localizedUppercase,
                    font: R.font.domaineSansTextLight(size: 18),
                    themeStyle: .silverColor, lineHeight: 1.25)
        return label
    }

    fileprivate func makeSourceInfoTextView() -> UITextView {
        let textColor = themeService.attrs.silverColor

        let styleGroup: StyleXML = {
            let style = Style {
                $0.font = R.font.atlasGroteskLight(size: 14)
                $0.color = textColor
            }

            let coronaDataProject = Style {
                $0.linkURL = AppLink.coronaDataCraper.websiteURL
                $0.underline = (NSUnderlineStyle.single, textColor)
            }

            let jupyterNotebook = Style {
                $0.linkURL = AppLink.formulaJupyter.websiteURL
                $0.underline = (NSUnderlineStyle.single, textColor)
            }

            return StyleXML(base: style, [
                "corona-data-project": coronaDataProject,
                "jupyter-notebook": jupyterNotebook
            ])
        }()

        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.attributedText = R.string.phrase.sourceInfo().set(style: styleGroup)
        textView.linkTextAttributes = [
            .foregroundColor: textColor
        ]
        return textView
    }

    fileprivate func makeViewOnJupyterButton() -> UIButton {
        let button = RightIconButton(
            title: R.string.localizable.viewOnJupyter().localizedUppercase,
            icon: R.image.mapLocation()!)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.numberOfLines = 0
        button.rx.tap.bind { [weak self] in
            self?.moveToJupyterNotebook()
        }.disposed(by: disposeBag)
        return button
    }

    fileprivate func makeLoadIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.style = .white

        thisViewModel.fetchTrendingStateRelay
            .map { $0 == .loading }
            .bind(to: indicator.rx.isAnimating)
            .disposed(by: disposeBag)

        return indicator
    }
}
