//
//  ButtonWithConfirmation.swift
//  Trippy
//
//  Created by Lim Chun Yong on 1/5/21.
//

import SwiftUI

struct ButtonWithConfirmation: View {
    let buttonName: String?
    let warning: String?
    let image: String?
    let callback: () -> Void
    let defaultWarning = "Are you sure?"
    @State private var showAlert = false

    var body: some View {
        Group {
            if let image = image {
                Image(systemName: image).foregroundColor(.red).onTapGesture {
                    showAlert = true
                }
            } else if let buttonName = buttonName {
                Button(buttonName) {
                    showAlert = true
                }
            }
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text(warning ?? defaultWarning),
                message: Text("This action cannot be reversed"),
                primaryButton: .destructive(Text("Confirm"), action: callback),
                secondaryButton: .cancel()
             )
        }

    }
}
