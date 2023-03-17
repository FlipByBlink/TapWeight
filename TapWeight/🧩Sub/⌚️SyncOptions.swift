import SwiftUI

struct 🅂yncOptions: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .onChange(of: 📱.ⓒontext) { $0.sendToWatchApp() }
            .task { 📱.ⓒontext.sendToWatchApp() } //For old users.
    }
}
