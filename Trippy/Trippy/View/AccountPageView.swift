//
//  AccountPageView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 17/3/21.
//

import SwiftUI

struct AccountPageView: View {
    @EnvironmentObject var session: SessionStore

    var body: some View {
        if let user = session.session {
            VStack(spacing: 10) {
                CircleImageView()
                Text("\(user.username)")
                    .bold()
                    .font(.headline)
                VStack {
                    Text("USERNAME")
                }
            }
            .padding()
        }
    }
}

struct AccountPageView_Previews: PreviewProvider {
    static func setUser() -> SessionStore {
        let sessionStore = SessionStore()
        sessionStore.session = User(
            id: "1", email: "1", username: "CAT", followersId: [], followingId: [])
        return sessionStore
    }

    static var previews: some View {
        AccountPageView()
            .environmentObject(setUser())
    }
}
