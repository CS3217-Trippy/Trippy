//
//  ContentView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 9/3/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore

    var body: some View {
        Group {
            if let user = session.session {
                Text("Welcome! \(user.username)")
                Button("SIGN OUT") {
                    self.session.signOut()
                }
                FollowersListView(viewModel: FollowersListViewModel(user: user))            } else {
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
//     @Environment(\.colorScheme) var colorScheme
//     var body: some View {
//         let storage = FBBucketListStorage()
//         let model = BucketModel(storage: storage)
//         let vm = BucketListViewModel(bucketModel: model)
//         BucketListView(viewModel: vm).background(colorScheme == .dark ? Color.darkBackground : Color.lightBackground)
//         }
// }
