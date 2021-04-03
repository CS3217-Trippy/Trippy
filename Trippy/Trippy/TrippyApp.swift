//
//  TrippyApp.swift
//  Trippy
//
//  Created by Lim Chun Yong on 9/3/21.
//

import SwiftUI
import Firebase

@main
struct TrippyApp: App {
    @Environment(\.scenePhase) var scenePhase
    @State var locationCoordinator = LocationCoordinator()
    var sessionWrapper = FBSessionWrapper()

    init() {
        FirebaseApp.configure()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        sessionWrapper.initializeSessionStore()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionWrapper.retrieveSessionStore())
                .environmentObject(locationCoordinator)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("ScenePhase: active")
                locationCoordinator.enableAccurateLocation()
            case .background:
                print("ScenePhase: background")
                locationCoordinator.enableApproximateLocation()
            default:
                return
            }
        }
    }
}
