//
//  ProfileService.swift
//  Autonomy
//
//  Created by thuyentruong on 11/26/19.
//  Copyright © 2019 Bitmark Inc. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class ProfileService {
    static var provider = MoyaProvider<ProfileAPI>(session: CustomMoyaSession.shared, plugins: Global.default.networkLoggerPlugin)

    static func create(metadata: [String: Any]) -> Single<Profile> {
        return Single.deferred {
            guard let currentAccount = Global.current.account else {
                Global.log.error(AppError.emptyCurrentAccount)
                return Single.never()
            }

            Global.log.info("[start] ProfileService.create")
            let encryptedPublicKey = currentAccount.encryptionKey.publicKey.hexEncodedString

            return provider.rx
                .requestWithRefreshJwt(
                    .create(encryptedPublicKey: encryptedPublicKey, metadata: metadata))
                .filterSuccess()
                .retryWhenTransientError()
                .asSingle()
                .map(Profile.self, atKeyPath: "result", using: Global.default.decoder)
        }
    }

    static func getMe() -> Single<Profile> {
        Global.log.info("[start] ProfileService.getMe")

        return provider.rx
            .requestWithRefreshJwt(.getMe)
            .filterSuccess()
            .retryWhenTransientError()
            .asSingle()
            .map(Profile.self, atKeyPath: "result", using: Global.default.decoder )
    }

    static func updateMe(metadata: [String: Any]) -> Completable {
        Global.log.info("[start] ProfileService.updateMe")

        return provider.rx
            .requestWithRefreshJwt(.updateMe(metadata: metadata))
            .filterSuccess()
            .retryWhenTransientError()
            .ignoreElements()
    }

    static func deleteMe() -> Completable {
        Global.log.info("[start] ProfileService.deleteMe")

        return provider.rx
            .requestWithRefreshJwt(.deleteMe)
            .filterSuccess()
            .retryWhenTransientError()
            .ignoreElements()
    }

    static func reportHere() -> Completable {
        Global.log.info("[start] ProfileService.reportHere")

        return provider.rx
            .requestWithRefreshJwt(.reportHere)
            .filterSuccess()
            .retryWhenTransientError()
            .ignoreElements()
    }
}
