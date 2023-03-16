import SwiftUI

struct 🅂yncOptions: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .onChange(of: 📱.ⓒontext) { $0.set() }
            .task { 📱.ⓒontext.set() } //For old users.
    }
}
