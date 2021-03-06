import SwiftUI

struct TopTabBar: View {
  @Binding var tabs: [String]
  @Binding var selection: Int
  let underlineColor: Color

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .center, spacing: 30) {
        ForEach(tabs, id: \.self) {
          self.tab(title: $0)
        }
      }.padding(.horizontal)
    }
    Divider().padding(.horizontal)
  }

  private func tab(title: String) -> some View {
    let index = self.tabs.firstIndex(of: title)!
    let isSelected = index == selection
    return Button(action: {
      withAnimation {
         self.selection = index
      }
    }) {
        Text(title)
          .font(.system(size: 25))
          .fontWeight(.semibold)
            .foregroundColor(isSelected ? .black : .gray)
        .overlay(Rectangle()
          .frame(height: 2)
          .foregroundColor(isSelected ? underlineColor : .clear)
          .padding(.top, 2)
          .transition(.move(edge: .bottom)), alignment: .bottomLeading)
    }
  }
}
