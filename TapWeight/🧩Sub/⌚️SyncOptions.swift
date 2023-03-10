import SwiftUI

struct 🅂yncOptions: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .onChange(of: 📱.ⓒontext) { $0.sync() }
            .task { 📱.ⓒontext.sync() }
    }
}
