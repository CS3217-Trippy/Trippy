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
                NavigationView {
                    VStack(spacing: 10) {
                        Text("Welcome! \(user.username)")
                        let storage = FBBucketListStorage()
                        let model = BucketModel(storage: storage)
                        let bucketListVM = BucketListViewModel(bucketModel: model)
                        let bucketListView = BucketListView(viewModel: bucketListVM)
                            .background(colorScheme == .dark ? Color.darkBackground : Color.lightBackground)
                        NavigationLink(destination: bucketListView) {
                            Text("BUCKET LIST")
                        }
                        NavigationLink(destination: FollowersListView(viewModel: FollowersListViewModel(user: user))) {
                            Text("FOLLOWERS")
                        }
                        NavigationLink(destination: AccountPageView(
                                        accountPageViewModel: AccountPageViewModel(session: session))) {
                            Text("ACCOUNT PAGE")
                        }
                        Button("SIGN OUT") {
                            _ = self.session.signOut()
                        }
                    }
                }.navigationViewStyle(StackNavigationViewStyle())
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
