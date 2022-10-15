//
//  APIService.swift
//  TestIOS
//
//  Created by MacBook on 15.10.2022.
//

import Foundation
import Moya

let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)

let apiProvider = MoyaProvider<APIService>(
    plugins: [
        networkLogger
    ])

enum APIService {
    case beers
}

extension APIService: TargetType {
    typealias Parameters = [String: Any]

    var baseURL: URL { URL(string: "https://api.punkapi.com/v2")! }

    var path: String {
        return "/beers"
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        Data()
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
