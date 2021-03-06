//
//  AutonomyTrendingViewModel.swift
//  Autonomy
//
//  Created by Thuyen Truong on 6/9/20.
//  Copyright © 2020 Bitmark Inc. All rights reserved.
//

import RxSwift
import RxCocoa

class AutonomyTrendingViewModel: ViewModel {

    // MARK: - Properties
    let autonomyObject: AutonomyObject!
    let reportItemsRelay = BehaviorRelay<[ReportItem]?>(value: nil)
    let fetchTrendingStateRelay = BehaviorRelay<LoadState>(value: .hide)

    // MARK: - Inits
    init(autonomyObject: AutonomyObject) {
        self.autonomyObject = autonomyObject
    }

    func fetchTrending(in datePeriod: DatePeriod) {
        fetchTrendingStateRelay.accept(.loading)

        TrendingService.getAutonomyTrending(autonomyObject: autonomyObject, in: datePeriod)
            .do(onDispose: { [weak self] in
                self?.fetchTrendingStateRelay.accept(.hide)
            })
            .subscribe(onSuccess: { [weak self] in
                self?.reportItemsRelay.accept($0)
            }, onError: { (error) in
                Global.backgroundErrorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
}
