import SwiftUI

 struct LocationRectangularCard<Content: View>: View {
     let viewBuilder: () -> Content
     @Environment(\.colorScheme) var colorScheme
     var body: some View {

        self.viewBuilder()
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .stroke(Color(.gray))
            )
            .padding([.top,.horizontal])
     }
 }
