//
//  AchievementListView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 13/4/21.
//

import SwiftUI

struct AchievementListView: View {
    @ObservedObject var viewModel: AchievementListViewModel
    @State private var selectedTab = 0
    var completedAchievements: some View {
        List {
            ForEach(viewModel.completedAchievementItems, id: \.id) { achievementViewModel in
                AchievementItemView(viewModel: achievementViewModel).frame(height: 200)
            }
        }
    }

    var uncompletedAchievements: some View {
        List {
            ForEach(viewModel.achievementItems, id: \.id) { achievementViewModel in
                AchievementItemView(viewModel: achievementViewModel).frame(height: 200)
            }
        }
    }

    var body: some View {
        VStack {
            TopTabBar(
                tabs: .constant(["Completed", "Uncompleted"]),
                selection: $selectedTab,
                underlineColor: .blue)
            if selectedTab == 0 {
                completedAchievements
            } else {
                uncompletedAchievements
            }
        }.navigationTitle("Achievements")
    }
}
