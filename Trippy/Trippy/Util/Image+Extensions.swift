import SwiftUI

extension Image {
    func locationImageModifier() -> some View {
        self
        .resizable()
        .aspectRatio(contentMode: .fit)
        .clipShape(
            RoundedRectangle(cornerRadius: 25.0)
        )
    }
    func cardImageModifier() -> some View {
        self
            .resizable()
            .frame(width: 150, height: 150, alignment: .center)
            .clipShape(Circle())
            .shadow(radius: 7)
            .padding(10)
    }
}
