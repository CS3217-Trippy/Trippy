//
//  ContentView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 9/3/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Group {
            if let user = session.session {
                HomepageView(homepageViewModel: HomepageViewModel(session: session), user: user)
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
            .environmentObject(SessionStore())
    }
}
