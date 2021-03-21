//
//  FBLocationStorage.swift
//  Trippy
//
//  Created by QL on 11/3/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation
import Combine
import Firebase
import UIKit

final class FBLocationStorage: LocationStorage, ObservableObject {
    var locations: Published<[Location]>.Publisher {
        $_locations
    }
    @Published private var _locations: [Location] = []
    private let path = "locations"
    private let store = Firestore.firestore()

    func fetchLocations() {
        store.collection(path).getDocuments { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            self._locations = snapshot?.documents.compactMap {
                guard let fbLocation = try? $0.data(as: FBLocation.self) else {
                    return nil
                }
                return self.convertFBLocationToLocation(fbLocation)
            } ?? []
        }
    }

    func addLocation(_ location: Location, with image: UIImage?) {
        guard let image = image else {
            self.addLocationDocument(location: location)
            return
        }

        let imageRef = Storage.storage().reference().child(UUID().uuidString + ".jpeg")
        addImage(image: image, imageRef: imageRef) { _, error in
            if let error = error {
                print("Error during storing of image: \(error.localizedDescription)")
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error during retrieval of image url: \(error.localizedDescription)")
                }
                location.imageURL = url
                self.addLocationDocument(location: location)
            }
        }
    }

    private func addLocationDocument(location: Location) {
        let fbLocation = convertLocationToFBLocation(location)
        do {
            location.id = try store.collection(path).addDocument(from: fbLocation).documentID
        } catch {
            print(error.localizedDescription)
        }
        _locations.append(location)
    }

    private func addImage(image: UIImage, imageRef: StorageReference,
                          completion: ((StorageMetadata?, Error?) -> Void)?) {
        guard let data = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        imageRef.putData(data, metadata: nil, completion: completion)
    }

    func updateLocation(_ location: Location) throws {
        let fbLocation = convertLocationToFBLocation(location)
        guard let locationId = fbLocation.id else {
            return
        }
        do {
            try store.collection(path).document(locationId).setData(from: fbLocation)
        } catch {
            throw StorageError.saveFailure
        }
        _locations.removeAll { $0.id == location.id }
        _locations.append(location)
    }

    func removeLocation(_ location: Location) {
        guard let locationId = location.id else {
            return
        }
        store.collection(path).document(locationId).delete()
        _locations.removeAll { $0.id == location.id }
    }

    private func convertLocationToFBLocation(_ location: Location) -> FBLocation {
        let imageURL = location.imageURL?.absoluteString
        return FBLocation(
                id: location.id,
                latitude: location.coordinates.latitude,
                longitude: location.coordinates.longitude,
                name: location.name,
                description: location.description,
                imageURL: imageURL
            )
    }

    private func convertFBLocationToLocation(_ fbLocation: FBLocation) -> Location {
        var imageURL: URL?
        if let url = fbLocation.imageURL {
            imageURL = URL(string: url)
        }
        return Location(
                id: fbLocation.id,
                coordinates: CLLocationCoordinate2D(latitude: fbLocation.latitude, longitude: fbLocation.longitude),
                name: fbLocation.name,
                description: fbLocation.description,
                imageURL: imageURL
            )
    }
}
