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

    func addLocation(_ location: Location) throws {
        do {
            let fbLocation = convertLocationToFBLocation(location)
            location.id = try store.collection(path).addDocument(from: fbLocation).documentID
        } catch {
            throw StorageError.saveFailure
        }
        _locations.append(location)
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
        let fbLocation = convertLocationToFBLocation(location)
        guard let locationId = fbLocation.id else {
            return
        }
        store.collection(path).document(locationId).delete { error in
            if let error = error {
                print("Unable to remove location: \(error.localizedDescription)")
            }
        }
        _locations.removeAll { $0.id == location.id }
    }

    private func convertLocationToFBLocation(_ location: Location) -> FBLocation {
        FBLocation(
            id: location.id,
            latitude: location.coordinates.latitude,
            longitude: location.coordinates.longitude,
            name: location.name,
            description: location.description
        )
    }

    private func convertFBLocationToLocation(_ fbLocation: FBLocation) -> Location {
        Location(
            id: fbLocation.id,
            coordinates: CLLocationCoordinate2D(latitude: fbLocation.latitude, longitude: fbLocation.longitude),
            name: fbLocation.name,
            description: fbLocation.description
        )
    }
}
