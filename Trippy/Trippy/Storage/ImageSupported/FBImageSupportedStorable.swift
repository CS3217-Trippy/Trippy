//
//  Storable.swift
//  Trippy
//
//  Created by QL on 24/3/21.
//

import FirebaseFirestoreSwift
import CoreGraphics

protocol FBImageSupportedStorable: FBStorable, FBImageStorable where ModelType: ImageSupportedModel {
    var imageURL: String? { get }
}
