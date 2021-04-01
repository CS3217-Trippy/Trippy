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

    var body: some View {
        Group {
            if let user = session.retrieveCurrentLoggedInUser() {
                HomepageView(homepageViewModel: .init(session: session, locationCoordinator: locationCoordinator),
                             user: user)
            } else {
                StartUpView()
            }
        }.onAppear(perform: {
            session.listen()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FBSessionStore())
    }
}
