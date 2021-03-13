//
//  LocationCardViewModel.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import Foundation

import Combine

class LocationCardViewModel: Identifiable, ObservableObject {
    @Published var location: Location
    private var cancellables: Set<AnyCancellable> = []
    private(set) var id = ""
    
    init(location: Location) {
        self.location = location
        $location
          .compactMap { $0.id }
          .assign(to: \.id, on: self)
          .store(in: &cancellables)
    }
}
