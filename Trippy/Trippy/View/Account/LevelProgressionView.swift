//
//  LevelProgressionView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 31/3/21.
//

import SwiftUI

struct LevelProgressionView: View {
    @ObservedObject var viewModel: LevelProgressionViewModel

    var body: some View {
        VStack {
            Text("LEVEL \(viewModel.level)")
                .font(.title2)
            ProgressView(value: viewModel.percentageToNextLevel, total: 100)
                .frame(width: 400, alignment: .center)
            Text("\(viewModel.experience) / \(viewModel.experienceToNextLevel) to the next level")
        }
    }
}

struct LevelProgressionView_Previews: PreviewProvider {
    static var previews: some View {
        LevelProgressionView(viewModel: LevelProgressionViewModel(session: FBSessionStore()))
    }
}
