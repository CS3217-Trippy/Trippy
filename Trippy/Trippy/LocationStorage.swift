//
//  LocationStorage.swift
//  Trippy
//
//  Created by QL on 10/3/21.
//

protocol LocationStorage {
    func getLocations() -> [Location]
    
    func addLocation(_ location: Location) throws
    
    func updateLocation(_ location: Location) throws
    
    func removeLocation(_ location: Location)
    
}
