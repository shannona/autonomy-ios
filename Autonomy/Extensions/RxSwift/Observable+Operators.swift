//
//  Observable+Operators.swift
//  Autonomy
//
//  Created by thuyentruong on 11/12/19.
//  Copyright © 2019 Bitmark Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

infix operator => : DefaultPrecedence
infix operator <=> : DefaultPrecedence

func => <Base>(textInput: TextInput<Base>, variable: BehaviorRelay<String>) -> Disposable {

    let bindToVariable = textInput.text
        .filterNil()
        .subscribe(onNext: { variable.accept($0) })

    return Disposables.create([bindToVariable])
}

func <=> <Base>(textInput: TextInput<Base>, variable: BehaviorRelay<String>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: textInput.text)

    let bindToVariable = textInput.text
        .filterNil()
        .subscribe(onNext: { variable.accept($0) })

    return Disposables.create(bindToUIDisposable, bindToVariable)
}

extension ObservableType {

    // materialize events; AND complete the subject when event is completed
    func materializeWithCompleted(to eventSubject: PublishSubject<Event<Self.Element>>) -> Disposable {
        return self.materialize()
            .subscribe(onNext: { (event) in
                eventSubject.onNext(event)
                if event.isCompleted {
                    eventSubject.onCompleted()
                }
            })
    }

    /// Retries the source observable sequence on transient error using a provided retry
    /// strategy.
    /// - parameter maxAttemptCount: Maximum number of times to repeat the
    /// sequence. `5` by default.
    func retryWhenTransientError(_ maxAttemptCount: Int = 5) -> Observable<Element> {
        return retryWhen { (errors: Observable<Error>) -> Observable<Int> in
            return errors.enumerated().flatMap { (attempt, error) -> Observable<Int> in
                if attempt >= maxAttemptCount - 1 || !error.isTransient {
                    return Observable.error(error)
                }
                return Observable.timer(.milliseconds(500), scheduler: MainScheduler.instance)
                    .take(1)
            }

        }
    }
}
