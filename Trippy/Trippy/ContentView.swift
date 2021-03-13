//
//  ContentView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 9/3/21.
//

import SwiftUI

struct ContentView: View {
    let vm = BucketListViewModel()
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        BucketListView(viewModel: vm).background(colorScheme == .dark ? Color.darkBackground : Color.lightBackground)
        }
}


