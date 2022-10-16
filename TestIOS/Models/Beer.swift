//
//  Beer.swift
//  TestIOS
//
//  Created by MacBook on 15.10.2022.
//

import Foundation
import RealmSwift

@objcMembers class Beer: Object, Decodable {
    dynamic var id: Int
    dynamic var name: String
    dynamic var tagline: String
    dynamic var image_url: String
    dynamic var abv: AbvCategory
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
