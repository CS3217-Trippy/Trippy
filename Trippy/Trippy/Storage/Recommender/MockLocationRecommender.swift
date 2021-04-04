//
//  MockLocationRecommender.swift
//  TrippyTests
//
//  Created by QL on 4/4/21.
//
@testable import Trippy
import Combine

class MockLocationRecommender: LocationRecommender {
    var recommendedItems: Published<[Location]>.Publisher {
        $_recommendedItems
    }
    @Published private var _recommendedItems: [Location] = []

    init() {
        fetch()
    }

    func fetch() {
    }
}
