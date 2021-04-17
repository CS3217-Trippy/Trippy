//
//  AddItineraryView.swift
//  Trippy
//
//  Created by Fidella Widjojo on 17/4/21.
//

import SwiftUI

struct AddItineraryView: View {
    let viewModel: AddItineraryItemViewModel
    @State private var showStorageError = false
    var body: some View {
        Button("Add to itinerary") {
            do {
                try viewModel.saveForm()
            } catch {
                showStorageError = true
            }
        }.alert(isPresented: $showStorageError) {
            Alert(
                title: Text("An error occurred while attempting to save the information.")
            )
        }
    }
}
