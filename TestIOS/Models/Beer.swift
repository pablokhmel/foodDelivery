//
//  Beer.swift
//  TestIOS
//
//  Created by MacBook on 15.10.2022.
//

import Foundation

struct Beer: Decodable {
    var id: Int
    var name: String
    var description: String
    var image_url: String
    var abv: AbvCategory
}

enum AbvCategory: Double, Decodable {
    case light
    case medium
    case hard
}

extension AbvCategory {
    init?(rawValue: Double) {
        switch rawValue {
        case 0..<5: self = .light
        case 5..<10: self = .medium
        default: self = .hard
        }
    }
}
