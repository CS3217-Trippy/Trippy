//
//  ContentView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 9/3/21.
//

import SwiftUI

struct ContentView: View {
    let vm = BucketListViewModel()
    var body: some View {
        BucketListView(viewModel: vm)
    }
}


