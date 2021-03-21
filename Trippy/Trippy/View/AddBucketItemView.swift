//
//  AddBucketItemView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 20/3/21.
//

import SwiftUI

struct AddBucketItemView: View {
    let viewModel: AddBucketItemViewModel
    @State private var userDescription: String = ""
    @State private var showStorageError = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Form {
            TextField("Notes", text: $userDescription)
            Button("Submit") {
                do {
                    try viewModel.saveForm(userDescription: userDescription)
                } catch {
                    showStorageError = true
                }
                if !showStorageError {
                    presentationMode.wrappedValue.dismiss()
                }
            }.alert(isPresented: $showStorageError) {
                Alert(
                    title: Text("An error occurred while attempting to save the information.")
                )
            }
        }.navigationBarTitle("Add to bucketlist")
    }
}
