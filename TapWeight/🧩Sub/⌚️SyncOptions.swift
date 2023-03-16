import SwiftUI

struct 🅂yncOptions: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .onChange(of: 📱.ⓒontext) { $0.save() }
            .task { 📱.ⓒontext.save() }
    }
}
