//
//  RealmService.swift
//  TestIOS
//
//  Created by MacBook on 16.10.2022.
//

import Foundation
import Realm
import RealmSwift

class RealmService {
    static let shared = RealmService()

    private var realm: Realm
    private var beers: Results<Beer>

    private init() {
        realm = try! Realm()
        beers = realm.objects(Beer.self)
    }

    func addBeer(model: Beer) {
        guard !beers.contains(where: { $0.name == model.name }) else { return }
        try! realm.write {
            realm.add(model)
        }
    }

    func getBeers() -> [Beer] {
        let objects = realm.objects(Beer.self)
        var array = [Beer]()
        objects.forEach { array.append($0) }
        return array
    }
}

extension RealmSwift.List: Decodable where Element: Decodable {
    public convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.singleValueContainer()
        let decodedElements = try container.decode([Element].self)
        self.append(objectsIn: decodedElements)
    }
}

extension RealmSwift.List: Encodable where Element: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.map { $0 })
    }
}
