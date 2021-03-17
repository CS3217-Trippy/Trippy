//
//  LocationStorage.swift
//  Trippy
//
//  Created by QL on 10/3/21.
//

import Combine

protocol LocationStorage {
    var locations: Published<[Location]>.Publisher { get }
    
    func fetchLocations()
    
    func addLocation(_ location: Location) throws
    
    func updateLocation(_ location: Location) throws
    
    func removeLocation(_ location: Location)
}
