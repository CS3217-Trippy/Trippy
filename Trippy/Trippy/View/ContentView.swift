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
    @EnvironmentObject var notificationManager: NotificationManager
    @State var showAlert = false
    @State var completedLocation = ""
    @State var showSubmitRatingSheet = false
    @State var alert = Alert(title: Text(""))

    func constructHomePageVM() -> HomepageViewModel {
        HomepageViewModel(
            session: session, locationCoordinator: locationCoordinator,
            notificationManager: notificationManager, showAlert: $showAlert,
            completedLocation: $completedLocation, alert: $alert, showSubmitRatingSheet: $showSubmitRatingSheet
        )
    }

    var body: some View {
        Group {
            if let user = session.currentLoggedInUser {
                let homepageViewModel = constructHomePageVM()
                HomepageView(
                    homepageViewModel: homepageViewModel,
                    user: user
                ).alert(isPresented: $showAlert) { alert }
                .sheet(isPresented: $showSubmitRatingSheet) {
                    SubmitRatingView(viewModel: SubmitRatingViewModel(
                                        locationId: completedLocation, userId: user.id ?? "",
                                        ratingModel: homepageViewModel.ratingModel
                    ))
                }
            } else {
                StartUpView(logInViewModel: .init(session: session))
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
