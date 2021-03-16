//
//  StartUpView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 15/3/21.
//

import SwiftUI

struct StartUpView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Trippy")
                    .font(.largeTitle)
                NavigationLink(destination: LogInView()) {
                    Text("LOG IN")
                }
                NavigationLink(destination: SignUpView()) {
                    Text("SIGN UP")
                }
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StartUpView_Previews: PreviewProvider {
    static var previews: some View {
        StartUpView()
    }
}
