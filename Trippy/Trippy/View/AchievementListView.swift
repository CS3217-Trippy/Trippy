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
        VStack {
            CollectionView(data: $viewModel.achievementItemViewModels, cols: 1, spacing: 10) { achievementViewModel in
                AchievementItemView(viewModel: achievementViewModel)
            }
        }
        .navigationTitle("ACHIEVEMENTS")
    }
}
