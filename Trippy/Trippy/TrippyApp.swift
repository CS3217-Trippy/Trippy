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

    init() {
        FirebaseApp.configure()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(FBSessionStore())
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
