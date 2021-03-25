//
//  FBStorable.swift
//  Trippy
//
//  Created by QL on 25/3/21.
//

import FirebaseFirestoreSwift
import CoreGraphics

protocol FBStorable: Identifiable, Codable {
    associatedtype ModelType: Model
    var id: String? { get }
    static var path: String { get }
    func convertToModelType() -> ModelType

    init(item: ModelType)
}
