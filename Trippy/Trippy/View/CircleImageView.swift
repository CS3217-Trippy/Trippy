//
//  CircleImageView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 17/3/21.
//

import SwiftUI
import URLImage

struct CircleImageView: View {
    var image: UIImage?
    let defaultPictureName = "cat"

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .frame(width: 300, height: 300, alignment: .center)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 7)
        } else {
            Image(defaultPictureName)
                .frame(width: 300, height: 300, alignment: .center)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 7)
        }
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircleImageView()
    }
}
