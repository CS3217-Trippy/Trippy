import SwiftUI

struct RectangularCard<Content: View>: View {
    let width: CGFloat
    let height: CGFloat
    let viewBuilder: () -> Content
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorScheme == .dark ? Color(.darkGray) : Color.white)		
                .frame(width: width, height: height)
            .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1),radius: 6,x: 6, y: 6)
            self.viewBuilder()
        }
    }
}
