//
//  SubmitRatingView.swift
//  Trippy
//
//  Created by QL on 14/4/21.
//

import SwiftUI

struct SubmitRatingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var score = 5.0
    @State private var isEditing = false
    var viewModel: SubmitRatingViewModel

    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
            }
            padding()
            Text("Please give a score of 1-5")
            Slider(value: $score, in: 1...5, step: 1, onEditingChanged: { editing in
                isEditing = editing
            }, minimumValueLabel: Text("1"), maximumValueLabel: Text("5")) {
                Text("Rating")
            }
            Text("\(Int(score))")
            .foregroundColor(isEditing ? .blue : .black)

            Button("Submit") {
                viewModel.submitRating(score: Int(score))
            }
        }
    }
}
