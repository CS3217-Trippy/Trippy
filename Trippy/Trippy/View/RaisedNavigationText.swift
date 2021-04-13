//
//  RaisedNavigationText.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/4/21.
//

import SwiftUI

struct RaisedNavigationText: View {
    var text: String
    var colorHex = "287bf7"
    var body: some View {
        Text(text)
            .frame(width: 400, height: 50, alignment: .center)
            .background(Color(hex: colorHex))
            .foregroundColor(Color.white)
    }
}
