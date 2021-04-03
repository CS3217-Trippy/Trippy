//
//  ContentView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 9/3/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: FBSessionStore
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var locationCoordinator: LocationCoordinator
    @State var showLocationAlert = false
    @State var alertTitle = ""
    @State var alertContent = ""

    var body: some View {
        Group {
            if let user = session.currentLoggedInUser {
                let homepageViewModel = HomepageViewModel(
                    session: session,
                    locationCoordinator: locationCoordinator,
                    showLocationAlert: $showLocationAlert,
                    alertTitle: $alertTitle,
                    alertContent: $alertContent
                )
                HomepageView(
                    homepageViewModel: homepageViewModel,
                    user: user
                )
            } else {
                StartUpView()
            }
        }.onAppear(perform: {
            session.listen()
        }).alert(isPresented: $showLocationAlert) {
            Alert(title: Text(alertTitle), message: Text(alertContent))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FBSessionStore())
    }
}
