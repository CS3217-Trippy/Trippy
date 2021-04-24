import SwiftUI

struct RaisedButton: View {
    let child: String
    var colorHex: String
    var width: CGFloat
    var callback: () -> Void
    var body: some View {
        Button(action: callback) {
            Text(child).foregroundColor(Color.white)
                .frame(width: width, height: 50)
        }
        .cornerRadius(5)
        .shadow(radius: 20)
        .background(Color(hex: colorHex))
    }
}
