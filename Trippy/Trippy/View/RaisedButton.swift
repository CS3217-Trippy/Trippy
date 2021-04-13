import SwiftUI

struct RaisedButton: View {
    let child: String
    var colorHex: String
    var callback: () -> Void
    var body: some View {
        Button(action: callback) {
            Text(child).foregroundColor(Color.white)
                .frame(width: 400, height: 50)
        }
        .cornerRadius(5)
        .shadow(radius: 20)
        .background(Color(hex: colorHex))
    }
}
