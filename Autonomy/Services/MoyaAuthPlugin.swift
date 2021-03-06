//
//  MoyaAuthPlugin.swift
//  Autonomy
//
//  Created by thuyentruong on 11/26/19.
//  Copyright © 2019 Bitmark Inc. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol AuthorizedTargetType: TargetType { }
protocol VersionTargetType: TargetType {}
protocol LocationTargetType: TargetType {}

struct MoyaAuthPlugin: PluginType {
    let tokenClosure: () -> String?

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard
            let _ = target as? AuthorizedTargetType,
            let token = tokenClosure()
            else {
                return request
        }

        var request = request
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
}

struct MoyaVersionPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard
            let _ = target as? VersionTargetType,
            let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            else {
                return request
        }

        var request = request
        request.addValue("ios", forHTTPHeaderField: "Client-Type")
        request.addValue(bundleVersion, forHTTPHeaderField: "Client-Version")
        return request
    }
}

struct MoyaLocationPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard
            let _ = target as? LocationTargetType,
            let locationCoordinate = Global.current.userLocationRelay.value?.coordinate
            else {
                return request
        }

        var request = request
        request.addValue("\(locationCoordinate.latitude);\(locationCoordinate.longitude)", forHTTPHeaderField: "Geo-Position")
        return request
    }
}
