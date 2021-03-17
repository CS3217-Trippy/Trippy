//
//  ContentView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 9/3/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let storage = FBBucketListStorage()
        let model = BucketModel(storage: storage)
        let vm = BucketListViewModel(bucketModel: model)
        BucketListView(viewModel: vm).background(colorScheme == .dark ? Color.darkBackground : Color.lightBackground)
        }
}


