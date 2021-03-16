//
//  FollowersItemView.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import SwiftUI

struct FollowersItemView: View {
    @ObservedObject var followersItemViewModel: FollowersItemViewModel

    var body: some View {
        RectangularCard(
            width: UIScreen.main.bounds.width - 10,
            height: 210,
            viewBuilder: { Text(followersItemViewModel.username) }
        )
    }
}

struct FollowersItemView_Previews: PreviewProvider {
    static var previews: some View {
        FollowersItemView(followersItemViewModel: FollowersItemViewModel(username: "Username"))
    }
}
