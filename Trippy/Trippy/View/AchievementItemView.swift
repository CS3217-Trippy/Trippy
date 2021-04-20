//
//  AchievementItemView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 13/4/21.
//

import SwiftUI

struct AchievementItemView: View {
    @ObservedObject var viewModel: AchievementItemViewModel

    var textView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(viewModel.achievementName)
                .bold()
                .font(.headline)
            Text(viewModel.achievementDescription).fontWeight(.light)
        }
    }

    var body: some View {
        RectangularCard(
            image: viewModel.image,
            isHorizontal: true
            ) {
            HStack(alignment: .center) {
                textView
                Spacer()
            }
        }
    }
}
