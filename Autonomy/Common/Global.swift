//
//  Global.swift
//  Autonomy
//
//  Created by thuyentruong on 11/12/19.
//  Copyright © 2019 Bitmark Inc. All rights reserved.
//

import Foundation
import BitmarkSDK
import Moya
import RxSwift
import RxCocoa

class Global {
    static var current = Global()
    static let `default` = current

    var account: Account?
    static let backgroundErrorSubject = PublishSubject<Error>()

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        //    let dateFormat = ISO8601DateFormatter()
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormat.dateFormat = "yyyy-MM-dd'T'H:m:ss.SSSS'Z"

        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            guard let date = dateFormat.date(from: dateString) else {
                throw "cannot decode date string \(dateString)"
            }
            return date
        })
        return decoder
    }()

    func setupCoreData() -> Completable {
        return Completable.create { (event) -> Disposable in
            guard let currentAccount = Global.current.account else {
                event(.error(AppError.emptyCurrentAccount))
                return Disposables.create()
            }

            do {
                try KeychainStore.saveToKeychain(currentAccount.seed.core, isSecured: false)
                event(.completed)
            } catch {
                event(.error(error))
            }
            return Disposables.create()
        }
    }

    let networkLoggerPlugin: [PluginType] = [
        NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(output: { (_, items) in
            for item in items {
                Global.log.info(item)
            }
        })),
        MoyaAuthPlugin(tokenClosure: {
            return AuthService.shared.auth?.jwtToken
        }),
        MoyaVersionPlugin()
    ]
}

enum AppError: Error {
    case emptyLocal
    case emptyCurrentAccount
    case emptyUserDefaults
    case emptyJWT
    case noInternetConnection

    static func errorByNetworkConnection(_ error: Error) -> Bool {
        guard let error = error as? Self else { return false }
        switch error {
        case .noInternetConnection:
            return true
        default:
            return false
        }
    }
}

enum AccountError: Error {
    case invalidRecoveryKey
}
