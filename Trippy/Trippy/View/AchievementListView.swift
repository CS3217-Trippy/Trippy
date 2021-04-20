//
//  AchievementListView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 13/4/21.
//

import SwiftUI

struct AchievementListView: View {
    @ObservedObject var viewModel: AchievementListViewModel
    var body: some View {
        List {
            ForEach(viewModel.achievementItemViewModels, id: \.id) { achievementViewModel in
                AchievementItemView(viewModel: achievementViewModel).frame(height: 200)
            }
        }
        .navigationTitle("ACHIEVEMENTS")
    }
}
