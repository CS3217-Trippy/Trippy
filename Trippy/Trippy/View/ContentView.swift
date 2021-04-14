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
    @State var completedLocation = ""
    @State private var showSubmitRatingSheet = false

    var body: some View {
        Group {
            if let user = session.currentLoggedInUser {
                let homepageViewModel = HomepageViewModel(
                    session: session,
                    locationCoordinator: locationCoordinator,
                    showLocationAlert: $showLocationAlert,
                    completedLocation: $completedLocation,
                    alertTitle: $alertTitle,
                    alertContent: $alertContent
                )
                HomepageView(
                    homepageViewModel: homepageViewModel,
                    user: user
                ).alert(isPresented: $showLocationAlert) {
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertContent),
                        primaryButton: .default(Text("Rate now"), action: { showSubmitRatingSheet.toggle() }),
                        secondaryButton: .cancel()
                    )
                }.sheet(isPresented: $showSubmitRatingSheet) {
                    SubmitRatingView(viewModel: SubmitRatingViewModel(
                                        locationId: completedLocation,
                                        userId: user.id ?? "",
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
