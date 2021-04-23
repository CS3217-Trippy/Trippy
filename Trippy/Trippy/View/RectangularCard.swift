import SwiftUI
import UIKit

struct RectangularCard<Content: View>: View {
    var image: UIImage?
    let isHorizontal: Bool
    let viewBuilder: () -> Content

    var imageView: some View {
         if let image = image {
            return AnyView(
                Image(uiImage: image).locationImageModifier()
            )
        } else {
            return AnyView(Image("Placeholder")
            .locationImageModifier())
        }
    }

    var body: some View {
        if isHorizontal {
            HStack {
                imageView
               self.viewBuilder()
                .padding()
            }
            .padding([.top, .horizontal])
        } else {
            VStack {
                imageView
                self.viewBuilder()
                .padding()
            }
            .padding([.top, .horizontal])
        }
    }
}
