//
//  AchievementItemView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 13/4/21.
//

import SwiftUI

struct AchievementItemView: View {
    @ObservedObject var viewModel: AchievementItemViewModel

    var imageView: some View {
        if let image = viewModel.image {
            return AnyView(Image(uiImage: image).cardImageModifier()
            )
        } else {
            return AnyView(Image("Placeholder").cardImageModifier())
        }
    }

    var textView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(viewModel.achievementName)
                .bold()
                .font(.headline)
            Text(viewModel.achievementDescription).fontWeight(.light)
            Image(systemName: "trash").foregroundColor(.red)
        }
    }

    var body: some View {
        RectangularCard(width: UIScreen.main.bounds.width - 10, height: 210, viewBuilder: {
            HStack(alignment: .center) {
                imageView
                textView
                Spacer()
            }
        })
    }
}
